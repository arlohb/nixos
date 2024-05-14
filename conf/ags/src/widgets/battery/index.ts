const battery = await Service.import("battery");

const percentToIcon = (icons: string[], percent: number): string => {
    const index = Math.round(percent * (icons.length - 1) / 100)
    return icons[index];
};

const batteryIcon = (percent: number, charging: boolean): string => {
    return percentToIcon(
        charging
            ? ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
            : ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        percent,
    );
};

export default (orientation: "H" | "V") => Widget.Box({
    orientation: orientation == "H" ? 0 : 1,
    spacing: 8,
    className: `widget nextcloud nextcloud${orientation}`,
    children: [
        Widget.Label({
            label: Utils.merge(
                [ battery.bind("percent"), battery.bind("charging") ],
                (percent, charging) => batteryIcon(percent, charging),
            ),
        }),
        Widget.Label({
            label: battery.bind("percent").as(percent => `${percent}%`),
        }),
    ],
});

