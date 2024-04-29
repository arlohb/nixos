import pcBar from "./windows/pcBar";
import laptopBar from "./windows/laptopBar";
import { listDirRecAbsolute } from "./utils";

const debug = false;

enum Host {
    ArloNix,
    ArloLaptop2,
    Debug,
}

const host = debug
    ? Host.Debug
    : Utils.exec("hostname") == "arlo-nix"
        ? Host.ArloNix
        : Host.ArloLaptop2;

/** Get all the css files in the src folder. */
const findCssFiles = (): string[] => {
    return [
        // This one needs to come first
        `${App.configDir}/src/style.css`,
        ...listDirRecAbsolute(`${App.configDir}/src`)
            .filter(name => name.endsWith(".css") && !name.endsWith("style.css"))
    ];
}

/** Compile all the css files in the src folder to one css src. */
const loadCss = (): string => {
    return findCssFiles()
        .map(Utils.readFile)
        .join("\n");
}

// Create app
App.config({
    windows: host == Host.ArloNix ? pcBar
        : host == Host.ArloLaptop2 ? laptopBar
        : [...pcBar(), ...laptopBar()],
});

// Apply css
App.applyCss(loadCss(), true);

// Make file a module for top level await
export {}

