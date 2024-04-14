import music from "./music";

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

Utils.monitorFile(
    App.configDir,
    async () => {
        const css = `${App.configDir}/style.css`;
        App.applyCss(css, true);
    }
)

App.config({
    style: "./style.css",
    windows: [bar],
});

// Make file a module for top level await
export {}

