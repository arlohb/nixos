const mpris = await Service.import("mpris");

const music = () => Widget.Box({
    vertical: true,
    spacing: 16,
    className: "widget",
}).hook(mpris, self => {
    const player = mpris.getPlayer();
    const icon = Widget.Icon({
        icon: player?.cover_path,
        size: 100,
    });
    self.children = [
        icon,
        Widget.Label({
            label: player?.track_title,
            wrap: true,
        }),
        Widget.Label({
            label: player?.track_album,
            wrap: true,
        }),
        Widget.Label({
            label: player?.track_artists.join(", "),
            wrap: true,
        }),
    ];
});

const bar = Widget.Window({
    name: "bar",
    anchor: ["left", "top", "bottom"],
    exclusivity: "exclusive",
    child: Widget.Box({
        spacing: 16,
        vertical: true,
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

