const mpris = await Service.import("mpris");

const icon = Widget.Icon({
    icon: mpris.bind("players").as(_ => mpris.getPlayer()?.cover_path ?? ""),
    size: 100,
});

const label = Widget.Label({
    label: "hello",
});

const bar = Widget.Window({
    name: "bar",
    anchor: ["left", "top", "bottom"],
    exclusivity: "exclusive",
    child: Widget.Box({
        vertical: true,
        children: [
            icon,
            label,
        ],
    }),
});

App.config({
    windows: [bar],
});

// Make file a module for top level await
export {}

