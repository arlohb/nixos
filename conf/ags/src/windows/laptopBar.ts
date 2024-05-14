import music from "@widgets/music";
import { clockH } from "@widgets/clock";
import nextcloud from "@widgets/nextcloud";
import { volume } from "@widgets/slider";
import bluetooth from "@widgets/bluetooth";
import type { BoxProps } from "types/widgets/box";

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
export default () => [Widget.Window({
    name: "laptopBar",
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
        spacing: 8,
        startWidget: container([
            music("H"),
        ]),
        centerWidget: container([
        ]),
        endWidget: container([
            bluetooth(),
            volume("H"),
            nextcloud("H"),
            clockH(),
        ], { hpack: "end" }),
    }),
})];

