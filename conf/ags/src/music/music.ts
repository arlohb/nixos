import Gtk from "types/@girs/gtk-3.0/gtk-3.0";

const mpris = await Service.import("mpris");

/**
 * An oddly specific function,
 * But "(Taylor's Version)" everywhere just clutters up the widget a bit.
 */
const remove_taylors_version = (str: string): string =>
    str.replace(" (Taylor's Version)", "");

export default () => Widget.Box({
    vertical: true,
    spacing: 12,
    className: "widget music",
}).hook(mpris, self => {
    const player = mpris.getPlayer();
    const children: Gtk.Widget[] = [];

    if (player?.cover_path) {
        children.push(
            Widget.Icon({
                icon: player?.cover_path,
                size: 60,
            })
        );
    }

    if (player?.track_title) {
        children.push(
            Widget.Label({
                label: remove_taylors_version(player?.track_title).clip(14),
                wrap: true,
            }),
        );
    }

    if (player?.track_album) {
        children.push(
            Widget.Label({
                label: remove_taylors_version(player?.track_album).clip(14),
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

