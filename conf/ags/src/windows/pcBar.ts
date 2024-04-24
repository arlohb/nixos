import music from "../music/music";
import clock from "../clock/clockV";
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
    vertical: true,
    className: "container",
    children,
    ...props
});


/** The bar window */
export default () => [Widget.Window({
    name: "pcBar",
    anchor: ["left", "top", "bottom"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
        spacing: 8,
        vertical: true,
        startWidget: container([
            music(),
        ]),
        centerWidget: container([
            clock(),
            nextcloud(),
        ]),
        endWidget: container([
            volume(),
        ], { vpack: "end" }),
    }),
})];

