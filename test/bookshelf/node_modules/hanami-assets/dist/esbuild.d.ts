import { BuildOptions, Plugin } from "esbuild";
import { Args } from "./args.js";
export interface EsbuildOptions extends Partial<BuildOptions> {
    plugins: Plugin[];
}
export declare const buildOptions: (root: string, args: Args) => EsbuildOptions;
export declare const watchOptions: (root: string, args: Args) => EsbuildOptions;
