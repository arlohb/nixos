import { getTime } from "./clock";

const time = getTime();

export default () => Widget.Box({
    vertical: true,
    className: "widget clockV",
    children: [
        Widget.Label({
            label: time.bind().as(({ hours }) => hours.toString().padStart(2, "0")),
        }),
        Widget.Label({
            label: time.bind().as(({ mins }) => mins.toString().padStart(2, "0")),
        }),
    ],
});

