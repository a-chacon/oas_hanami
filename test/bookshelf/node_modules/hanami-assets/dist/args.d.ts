export interface Args {
    path: string;
    dest: string;
    watch: Boolean;
    sri: string[] | null;
}
export declare const parseArgs: (args: string[]) => Args;
