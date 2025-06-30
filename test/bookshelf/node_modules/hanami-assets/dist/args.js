export const parseArgs = (args) => {
    const result = {};
    args.forEach((arg) => {
        const [key, value] = arg.replace(/^--/, "").split("=");
        result[key] = value;
    });
    return {
        path: result["path"],
        dest: result["dest"],
        watch: result.hasOwnProperty("watch"),
        sri: result["sri"]?.split(","),
    };
};
