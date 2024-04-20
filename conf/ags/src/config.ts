import "./utils";
import music from "./music";
import clock from "./clock";
import nextcloud from "./nextcloud";
import volume from "./volume";
import type { BoxProps } from "types/widgets/box";

/** Directory with all the css styles */
const stylesPath = `${App.configDir}/styles`;

/** Contains widgets.
* Use 3 of these, in top, center, and bottom. */
const container = (
    children: BoxProps["children"],
    props?: BoxProps
) => Widget.Box({
    spacing: 8,
    vertical: true,
    className: "container",
    children,
    ...props
});

/** The bar window */
const bar = Widget.Window({
    name: "bar",
    anchor: ["left", "top", "bottom"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
        spacing: 8,
        vertical: true,
        startWidget: container([
            music(),
        ]),
        centerWidget: container([
            clock(),
            nextcloud(),
        ]),
        endWidget: container([
            volume(),
        ], { vpack: "end" }),
    }),
});

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
App.config({ windows: [bar] });

// Apply css
applyCss();
// Reload css when style changes
Utils.monitorFile(stylesPath, applyCss);

// Make file a module for top level await
export {}

