import music from "../music/music";
import clock from "../clock/clockH";
import nextcloud from "../nextcloud/nextcloud";
import volume from "../volume/volume";
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
            music(),
        ]),
        centerWidget: container([
        ]),
        endWidget: container([
            volume("H"),
            nextcloud(),
            clock(),
        ], { hpack: "end" }),
    }),
})];
