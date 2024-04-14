const { speaker } = await Service.import("audio");

export default () => Widget.Box({
    className: "widget volume",
    spacing: 8,
    vertical: true,
    children: [
        Widget.Label("󰕾"),
        Widget.Slider({
            orientation: 1,
            onChange: ({ value }) => speaker.volume = value,
            value: speaker.bind("volume"),
            drawValue: false,
        }),
    ],
});

