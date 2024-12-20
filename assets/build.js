// const esbuild = require("esbuild");
import esbuild from "esbuild"
import esbuildPluginTsc from "esbuild-plugin-tsc";
import { wasmLoader } from "esbuild-plugin-wasm"

const args = process.argv.slice(2);
const watch = args.includes('--watch');
const deploy = args.includes('--deploy');

const loader = {
    // Add loaders for images/fonts/etc, e.g. { '.svg': 'file' }
};

const plugins = [
    wasmLoader(),
    esbuildPluginTsc({
        force: true
    }),
];

// Define esbuild options
let opts = {
    entryPoints: ["js/app.js"],
    bundle: true,
    logLevel: "info",
    target: "esnext",
    outdir: "../priv/static/assets",
    external: ["*.css", "fonts/*", "images/*"],
    nodePaths: ["../deps"],
    loader: loader,
    plugins: plugins,
    format: "esm"
};

if (deploy) {
    opts = {
        ...opts,
        minify: true,
    };
}

if (watch) {
    opts = {
        ...opts,
        sourcemap: "inline",
    };
    esbuild
        .context(opts)
        .then((ctx) => {
            ctx.watch();
        })
        .catch((_error) => {
            process.exit(1);
        });
} else {
    esbuild.build(opts);
}