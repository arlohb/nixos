import type { BoxProps } from "types/widgets/box";
import music from "@widgets/music";
import clock from "@widgets/clock";
import nextcloud from "@widgets/nextcloud";
import { brightness, volume } from "@widgets/slider";
import bluetooth from "@widgets/bluetooth";
import { getMainMonitor } from "@utils";

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
export default () => Widget.Window({
    name: "pcBar",
    anchor: ["left", "top", "bottom"],
    exclusivity: "exclusive",
    layer: "bottom",
    child: Widget.CenterBox({
        spacing: 8,
        vertical: true,
        startWidget: container([
            music("V"),
        ]),
        centerWidget: container([
            clock("V"),
            nextcloud("V"),
        ]),
        endWidget: container([
            bluetooth("V"),
            brightness("V"),
            volume("V"),
        ], { vpack: "end" }),
    }),
    monitor: getMainMonitor(),
});

