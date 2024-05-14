import type { ButtonProps } from "types/widgets/button";

export default (
    label: string,
    onPrimaryClick?: ButtonProps["onPrimaryClick"],
    onSecondaryClick?: ButtonProps["onSecondaryClick"],
    onMiddleClick?: ButtonProps["onMiddleClick"],
) => Widget.Button({
    className: "widget button",
    label,
    ...onPrimaryClick ? { onPrimaryClick } : {},
    ...onSecondaryClick ? { onSecondaryClick } : {},
    ...onMiddleClick ? { onMiddleClick } : {},
});

