import type { SliderProps } from "types/widgets/slider";
import brightnessService from "@services/brightness";
import type { Binding } from "types/service";

const { speaker } = await Service.import("audio");

const slider = (
    icon: string | Binding<any, any, string>,
    value: number | Binding<any, any, number>,
    onChange: SliderProps["onChange"],
) => (
    orientation: "H" | "V",
) => Widget.Box({
    className: `widget slider slider${orientation}`,
    orientation : orientation == "H" ? 0 : 1,
    children: [
        Widget.Label({
            label: icon,
        }),
        Widget.Slider({
            orientation : orientation == "H" ? 0 : 1,
            drawValue: false,
            onChange,
            value,
        }),
    ],
});

export default slider;

// speaker.stream is used for real is_muted, but isn't changed when needed
// So whenever speaker is changed, trigger a change on stream
speaker.connect("changed", _speaker => {
    speaker.notify("stream");
});

export const volume = slider(
    speaker.bind("stream").as(stream => stream?.is_muted ? "󰝟" : "󰕾"),
    speaker.bind("volume"),
    ({ value }) => speaker.volume = value,
);

export const brightness = slider(
    "",
    brightnessService
        ? brightnessService.bind("percent")
        : 0,
    ({ value }) => {
        if (brightnessService)
            brightnessService.percent = value;
    },
)

