import Gtk from "types/@girs/gtk-3.0/gtk-3.0";

const mpris = await Service.import("mpris");

export default () => Widget.Box({
    vertical: true,
    spacing: 16,
    className: "widget music",
}).hook(mpris, self => {
    const player = mpris.getPlayer();
    const children: Gtk.Widget[] = [];

    if (player?.cover_path && player?.cover_path !== "") {
        children.push(
            Widget.Icon({
                icon: player?.cover_path,
                size: 100,
            })
        );
    }

    if (player?.track_title && player?.track_title !== "") {
        children.push(
            Widget.Label({
                label: player?.track_title,
                wrap: true,
            }),
        );
    }

    if (player?.track_album && player?.track_album !== "") {
        children.push(
            Widget.Label({
                label: player?.track_album,
                wrap: true,
            })
        );
    }

    if (player?.track_artists && player?.track_artists.length !== 0) {
        children.push(
            Widget.Label({
                label: player?.track_artists.join(", "),
                wrap: true,
            }),
        );
    }

    self.children = children;
});

