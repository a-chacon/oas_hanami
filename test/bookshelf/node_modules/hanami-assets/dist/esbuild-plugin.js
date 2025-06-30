import fs from "fs-extra";
import path from "path";
import crypto from "node:crypto";
import { globSync } from "glob";
const URL_SEPARATOR = "/";
const assetsDirName = "assets";
const fileHashRegexp = /(-[A-Z0-9]{8})(\.\S+)$/;
const hanamiEsbuild = (options) => {
    return {
        name: "hanami-esbuild",
        setup(build) {
            build.initialOptions.metafile = true;
            const manifestPath = path.join(options.root, options.destDir, "assets.json");
            const assetsSourceDir = path.join(options.sourceDir, assetsDirName);
            const assetsSourcePath = path.join(options.root, assetsSourceDir);
            // Track files loaded by esbuild so we don't double-process them.
            const loadedFiles = new Set();
            build.onLoad({ filter: /.*/ }, (args) => {
                loadedFiles.add(args.path);
                return null;
            });
            // After build, copy over any non-referenced asset files, and create a manifest.
            build.onEnd(async (result) => {
                const outputs = result.metafile?.outputs;
                const manifest = {};
                if (typeof outputs === "undefined") {
                    return;
                }
                // Copy extra asset files (in dirs besides js/ and css/) into the destination directory
                const copiedAssets = [];
                assetDirectories().forEach((dir) => {
                    copiedAssets.push(...processAssetDirectory(dir));
                });
                // Add copied assets into the manifest
                for (const copiedAsset of copiedAssets) {
                    if (copiedAsset.sourcePath.endsWith(".map")) {
                        continue;
                    }
                    // Take the full path of the copied asset and remove everything up to (and including) the "assets/" dir
                    var sourceUrl = copiedAsset.sourcePath.replace(assetsSourcePath + path.sep, "");
                    // Then remove the first subdir (e.g. "images/"), since we do not include those in the asset paths
                    sourceUrl = sourceUrl.substring(sourceUrl.indexOf("/") + 1);
                    manifest[sourceUrl] = prepareAsset(copiedAsset.destPath);
                }
                // Add files already bundled by esbuild into the manifest
                for (const outputFile in outputs) {
                    if (outputFile.endsWith(".map")) {
                        continue;
                    }
                    const outputAttrs = outputs[outputFile];
                    const inputFiles = Object.keys(outputAttrs.inputs);
                    // Determine the manifest key for the esbuild output file
                    let manifestKey;
                    if (!(outputFile.endsWith(".js") || outputFile.endsWith(".css")) &&
                        inputFiles.length == 1 &&
                        inputFiles[0].startsWith(assetsSourceDir + path.sep)) {
                        // A non-JS/CSS output with a single input will be an asset file that has been been
                        // referenced from JS/CSS.
                        //
                        // In this case, preserve the original input file's path in the manifest key, so it
                        // matches any other files copied over from that path via processAssetDirectory.
                        //
                        // For example, given the input file "app/assets/images/icons/some-icon.png", return a
                        // manifest key of "icons/some-icon.png".
                        manifestKey = inputFiles[0]
                            .substring(assetsSourceDir.length + 1) // + 1 to account for the sep
                            .split(path.sep)
                            .slice(1)
                            .join(path.sep);
                    }
                    else {
                        // For all other outputs, determine the manifest key based on the output file name,
                        // stripping away the hash suffix added by esbuild.
                        //
                        // For example, given the output "public/assets/app-2TLUHCQ6.js", return an manifest
                        // key of "app.js".
                        manifestKey = outputFile
                            .replace(options.destDir + path.sep, "")
                            .replace(fileHashRegexp, "$2");
                    }
                    manifest[manifestKey] = prepareAsset(outputFile);
                }
                // Write assets manifest to the destination directory
                await fs.writeJson(manifestPath, manifest, { spaces: 2 });
                //
                // Helper functions
                //
                function assetDirectories() {
                    const excludeDirs = ["js", "css"];
                    try {
                        const dirs = globSync([path.join(assetsSourcePath, "*")], { nodir: false });
                        const filteredDirs = dirs.filter((dir) => {
                            const dirName = dir.split(path.sep).pop();
                            return !excludeDirs.includes(dirName);
                        });
                        return filteredDirs;
                    }
                    catch (err) {
                        console.error("Error listing external directories:", err);
                        return [];
                    }
                }
                function processAssetDirectory(assetDir) {
                    const files = fs.readdirSync(assetDir, { recursive: true });
                    const assets = [];
                    files.forEach((file) => {
                        const sourcePath = path.join(assetDir, file.toString());
                        // Skip files loaded by esbuild; those are added to the manifest separately
                        if (loadedFiles.has(sourcePath)) {
                            return;
                        }
                        // Skip directories and any other non-files
                        if (!fs.statSync(sourcePath).isFile()) {
                            return;
                        }
                        const fileHash = calculateHash(fs.readFileSync(sourcePath), options.hash);
                        const fileExtension = path.extname(sourcePath);
                        const baseName = path.basename(sourcePath, fileExtension);
                        const destFileName = [baseName, fileHash].filter((item) => item !== null).join("-") + fileExtension;
                        const destPath = path.join(options.destDir, path
                            .relative(assetDir, sourcePath)
                            .replace(path.basename(file.toString()), destFileName));
                        if (fs.lstatSync(sourcePath).isDirectory()) {
                            assets.push(...processAssetDirectory(destPath));
                        }
                        else {
                            copyAsset(sourcePath, destPath);
                            assets.push({ sourcePath: sourcePath, destPath: destPath });
                        }
                    });
                    return assets;
                }
                // TODO: profile the current implementation vs blindly copying the asset
                function copyAsset(srcPath, destPath) {
                    if (fs.existsSync(destPath)) {
                        const srcStat = fs.statSync(srcPath);
                        const destStat = fs.statSync(destPath);
                        // File already exists and is up-to-date, skip copying
                        if (srcStat.mtimeMs <= destStat.mtimeMs) {
                            return;
                        }
                    }
                    if (!fs.existsSync(path.dirname(destPath))) {
                        fs.mkdirSync(path.dirname(destPath), { recursive: true });
                    }
                    fs.copyFileSync(srcPath, destPath);
                    return;
                }
                function prepareAsset(assetPath) {
                    var asset = { url: calculateDestinationUrl(assetPath) };
                    if (options.sriAlgorithms.length > 0) {
                        asset.sri = [];
                        for (const algorithm of options.sriAlgorithms) {
                            const subresourceIntegrity = calculateSubresourceIntegrity(algorithm, path.join(options.root, assetPath));
                            asset.sri.push(subresourceIntegrity);
                        }
                    }
                    return asset;
                }
                function calculateDestinationUrl(str) {
                    const normalizedUrl = str.replace(/[\\]+/, URL_SEPARATOR);
                    return normalizedUrl.replace(/public/, "");
                }
                function calculateSubresourceIntegrity(algorithm, path) {
                    const content = fs.readFileSync(path, "utf8");
                    const hash = crypto.createHash(algorithm).update(content).digest("base64");
                    return `${algorithm}-${hash}`;
                }
                // Inspired by https://github.com/evanw/esbuild/blob/2f2b90a99d626921d25fe6d7d0ca50bd48caa427/internal/bundler/bundler.go#L1057
                function calculateHash(hashBytes, hash) {
                    if (!hash) {
                        return null;
                    }
                    const result = crypto.createHash("sha256").update(hashBytes).digest("hex");
                    return result.slice(0, 8).toUpperCase();
                }
            });
        },
    };
};
export default hanamiEsbuild;
