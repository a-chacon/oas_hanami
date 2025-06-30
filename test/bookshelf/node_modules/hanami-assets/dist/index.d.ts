import { BuildContext } from "esbuild";
import { Args } from "./args.js";
import { EsbuildOptions } from "./esbuild.js";
interface RunOptions {
    root?: string;
    argv?: string[];
    esbuildOptionsFn?: EsbuildOptionsFn;
}
type EsbuildOptionsFn = (args: Args, esbuildOptions: EsbuildOptions) => EsbuildOptions;
export declare const run: (options?: RunOptions) => Promise<BuildContext | void>;
export {};
