const { speaker } = await Service.import("audio");

export default (orientation: "H" | "V") => Widget.Box({
    className: `widget volume volume${orientation}`,
    spacing: 8,
    orientation : orientation == "H" ? 0 : 1,
    children: [
        Widget.Label("󰕾"),
        Widget.Slider({
            orientation : orientation == "H" ? 0 : 1,
            onChange: ({ value }) => speaker.volume = value,
            value: speaker.bind("volume"),
            drawValue: false,
        }),
    ],
});

