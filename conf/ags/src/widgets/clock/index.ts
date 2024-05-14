export const getTime = () => Variable({ hours: 0, mins: 0 }, {
    poll: [1000, () => {
        const date = new Date();
        return {
            hours: date.getHours(),
            mins: date.getMinutes(),
        };
    }],
});

const time = getTime();

export const clockH = () => Widget.Box({
    className: "widget clockH",
    children: [
        Widget.Label({
            label: time.bind().as(({ hours, mins }) =>
                `${hours.toString().padStart(2, "0")}:${mins.toString().padStart(2, "0")}`),
        }),
    ],
});

export const clockV = () => Widget.Box({
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


