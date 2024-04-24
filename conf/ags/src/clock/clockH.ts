import { getTime } from "./clock";

const time = getTime();

export default () => Widget.Label({
    className: "widget clockH",
    label: time.bind().as(({ hours, mins }) =>
        `${hours.toString().padStart(2, "0")}:${mins.toString().padStart(2, "0")}`),
});

