import Gtk from "types/@girs/gtk-3.0/gtk-3.0";

const mpris = await Service.import("mpris");

export default () => Widget.Box({
    vertical: true,
    spacing: 16,
    className: "widget music",
}).hook(mpris, self => {
    const player = mpris.getPlayer();
    const children: Gtk.Widget[] = [];

    if (player?.cover_path) {
        children.push(
            Widget.Icon({
                icon: player?.cover_path,
                size: 100,
            })
        );
    }

    if (player?.track_title) {
        children.push(
            Widget.Label({
                label: player?.track_title.clip(14),
                wrap: true,
            }),
        );
    }

    if (player?.track_album) {
        children.push(
            Widget.Label({
                label: player?.track_album.clip(14),
                wrap: true,
            })
        );
    }

    if (player?.track_artists) {
        children.push(
            Widget.Label({
                label: player?.track_artists.join(", ").clip(14),
                wrap: true,
            }),
        );
    }

    self.children = children;
});

