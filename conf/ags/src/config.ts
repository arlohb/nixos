import "./utils";
import pcBar from "./pcBar";
import laptopBar from "./laptopBar";

const debug = true;

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

/** Directory with all the css styles */
const stylesPath = `${App.configDir}/styles`;

/** Load the CSS files and return one css src text. */
const loadCss = (): string => {
    // Find files in styles/
    return Utils.exec(`ls ${stylesPath}`)
        .split("\n")
        // Sort putting style.css first
        // So it can be overwritten in other files
        .sort((a, b) => {
            if (a == "style.css") return -1;
            if (b == "style.css") return 1;
            return 0;
        })
        // Relative => absolute paths
        .map(name => `${stylesPath}/${name}`)
        // Read the files
        .map(Utils.readFile)
        // Join the files
        .join("\n");
};

/** Apply the CSS to the app. */
const applyCss = (): void => App.applyCss(loadCss(), true);

// Create app
App.config({
    windows: host == Host.ArloNix ? pcBar
        : host == Host.ArloLaptop2 ? laptopBar
        : [...pcBar(), ...laptopBar()],
});

// Apply css
applyCss();
// Reload css when style changes
Utils.monitorFile(stylesPath, applyCss);

// Make file a module for top level await
export {}

