import { getTime } from "./clock";

const time = getTime();

export default () => Widget.Box({
    className: "widget clockH",
    children: [
        Widget.Label({
            label: time.bind().as(({ hours, mins }) =>
                `${hours.toString().padStart(2, "0")}:${mins.toString().padStart(2, "0")}`),
        }),
    ],
});

