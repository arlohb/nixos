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

export default (orientation: "H" | "V") => Widget.EventBox({
    onPrimaryClick: () => Utils.execAsync("gnome-clocks"),
    onSecondaryClick: () => Utils.execAsync("gnome-calendar"),
    child: Widget.Box({
        className: `widget clock clock${orientation}`,
        orientation: orientation === "H" ? 0 : 1,
        children: orientation === "H"
            ? [
                Widget.Label({
                    label: time
                        .bind()
                        .as(({ hours, mins }) =>
                            `${hours.toString().padStart(2, "0")}:${mins.toString().padStart(2, "0")}`
                        ),
                }),
            ]
            : [
                Widget.Label({
                    label: time.bind().as(({ hours }) => hours.toString().padStart(2, "0")),
                }),
                Widget.Label({
                    label: time.bind().as(({ mins }) => mins.toString().padStart(2, "0")),
                }),
            ],
    }),
});

