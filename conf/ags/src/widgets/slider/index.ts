import type { SliderProps } from "types/widgets/slider";

const { speaker } = await Service.import("audio");

const slider = (
    icon: string,
    value: SliderProps["value"],
    onChange: SliderProps["onChange"],
) => (
    orientation: "H" | "V",
) => Widget.Box({
    className: `widget slider slider${orientation}`,
    spacing: 8,
    orientation : orientation == "H" ? 0 : 1,
    children: [
        Widget.Label(icon),
        Widget.Slider({
            orientation : orientation == "H" ? 0 : 1,
            drawValue: false,
            onChange,
            value,
        }),
    ],
});

export default slider;

export const volume = slider(
    "󰕾",
    speaker.bind("volume"),
    ({ value }) => speaker.volume = value,
);

