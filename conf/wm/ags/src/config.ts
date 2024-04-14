import "./utils.ts";
import music from "./music";

/** Directory with all the css styles */
const stylesPath = `${App.configDir}/styles`;

/** The bar window */
const bar = Widget.Window({
    name: "bar",
    anchor: ["left", "top", "bottom"],
    exclusivity: "exclusive",
    child: Widget.Box({
        spacing: 8,
        vertical: true,
        className: "container",
        children: [music(), music(), music()],
    }),
});

/** Load the CSS files and return one css src text. */
const loadCss = (): string => {
    // Find files in styles/
    return Utils.exec(`ls ${stylesPath}`)
        .split("\n")
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
App.config({ windows: [bar] });

// Apply css
applyCss();
// Reload css when style changes
Utils.monitorFile(stylesPath, applyCss);

// Make file a module for top level await
export {}

