import fs from "fs-extra";
import path from "path";
import esbuild from "esbuild";
import { parseArgs } from "./args.js";
import { buildOptions, watchOptions } from "./esbuild.js";
export const run = async function (options) {
    // TODO: Allow root to be provided (optionally) as a --root arg
    const { root = process.cwd(), argv = process.argv, esbuildOptionsFn = null } = options || {};
    const args = parseArgs(argv);
    // TODO: make nicer
    let esbuildOptions = args.watch ? watchOptions(root, args) : buildOptions(root, args);
    if (esbuildOptionsFn) {
        esbuildOptions = esbuildOptionsFn(args, esbuildOptions);
    }
    const errorHandler = (err) => {
        console.log(err);
        process.exit(1);
    };
    if (args.watch) {
        touchManifest(root);
        const ctx = await esbuild.context(esbuildOptions);
        await ctx.watch().catch(errorHandler);
        return ctx;
    }
    else {
        await esbuild.build(esbuildOptions).catch(errorHandler);
    }
};
const touchManifest = (root) => {
    const manifestPath = path.join(root, "public", "assets.json");
    const manifestDir = path.dirname(manifestPath);
    fs.ensureDirSync(manifestDir);
    fs.writeFileSync(manifestPath, JSON.stringify({}, null, 2));
};
