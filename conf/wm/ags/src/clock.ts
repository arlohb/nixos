const time = Variable({ hours: 0, mins: 0 }, {
    poll: [1000, () => {
        const date = new Date();
        return {
            hours: date.getHours(),
            mins: date.getMinutes(),
        };
    }],
});

export default () => Widget.Box({
    vertical: true,
    className: "widget clock",
    children: [
        Widget.Label({
            label: time.bind().as(({ hours }) => hours.toString().padStart(2, "0")),
        }),
        Widget.Label({
            label: time.bind().as(({ mins }) => mins.toString().padStart(2, "0")),
        }),
    ],
});

