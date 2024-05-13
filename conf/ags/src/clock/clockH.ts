import { ResizeMode } from "types/@girs/gtk-3.0/gtk-3.0.cjs";
import { getTime } from "./clock";

const time = getTime();

export default () => Widget.Box({
    className: "widget clockH",
    // Fixes some resize issue
    resizeMode: ResizeMode.QUEUE,
    children: [
        Widget.Label({
            label: time.bind().as(({ hours, mins }) =>
                `${hours.toString().padStart(2, "0")}:${mins.toString().padStart(2, "0")}`),
        }),
    ],
});

