const time = Variable({ hours: 0, mins: 0 }, {
    poll: [1000, () => {
        const date = new Date();
        return {
            hours: date.getHours(),
            mins: date.getMinutes(),
        };
    }],
});

export default () => Widget.Label({
    className: "widget clockH",
    label: time.bind().as(({ hours, mins }) =>
        `${hours.toString().padStart(2, "0")}:${mins.toString().padStart(2, "0")}`),
});

