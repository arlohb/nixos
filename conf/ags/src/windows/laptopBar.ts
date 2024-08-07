import music from "@widgets/music";
import clock from "@widgets/clock";
import nextcloud from "@widgets/nextcloud";
import { brightness, volume } from "@widgets/slider";
import bluetooth from "@widgets/bluetooth";
import battery from "@widgets/battery";
import button from "@widgets/button";
import type { BoxProps } from "types/widgets/box";
import { cmdExists, getMainMonitor } from "@utils";

/** Contains widgets.
* Use 3 of these, in top, center, and bottom. */
const container = (
    children: BoxProps["children"],
    props?: BoxProps
) => Widget.Box({
    spacing: 8,
    className: "container",
    children,
    ...props
});

/** The bar window */
export default () => Widget.Window({
    name: "laptopBar",
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    layer: "bottom",
    child: Widget.CenterBox({
        spacing: 8,
        startWidget: container([
            button("󰣇", () => Utils.execAsync("rofi -show drun")),
            button("󰴓", () => Utils.execAsync(`${Utils.HOME}/.config/hypr/rotate.sh 1`)),
            button("󰌢", () => Utils.execAsync(`${Utils.HOME}/.config/hypr/rotate.sh 0`)),
            button("󰑦", () => Utils.execAsync("hyprctl dispatch togglesplit")),
            // TODO: Change icon to "󰌌" based on `wl_keys auto query` or internal state
            button("󰌐", () => Utils.execAsync("wl_keys auto toggle")),
            button("󰧹", () => Utils.execAsync("wl_keys ui toggle")),
        ]),
        centerWidget: container([
            ...[1, 2, 3, 4]
                .map(i => button(
                    ` ${i}`,
                    () => Utils.execAsync(`hyprctl dispatch workspace ${i}`)
                )),
            button(" X", () => Utils.execAsync("hyprctl dispatch killactive")),
            Widget.Separator(),
            // TODO: Don't show this and a couple other is portrait
            music("H"),
        ]),
        endWidget: container(
            [
                cmdExists("bluetoothctl") ? bluetooth("H") : null,
                cmdExists("brightnessctl") ? brightness("H") : null,
                cmdExists("pw-cli") ? volume("H") : null,
                cmdExists("nextcloudcmd") ? nextcloud("H") : null,
                cmdExists("upower") ? battery("H") : null,
                clock("H"),
            ].filter(widget => widget !== null) as BoxProps["children"],
            { hpack: "end" },
        ),
    }),
    monitor: getMainMonitor(),
});

