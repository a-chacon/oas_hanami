import { Plugin } from "esbuild";
export interface PluginOptions {
    root: string;
    sourceDir: string;
    destDir: string;
    sriAlgorithms: Array<string>;
    hash: boolean;
}
declare const hanamiEsbuild: (options: PluginOptions) => Plugin;
export default hanamiEsbuild;
