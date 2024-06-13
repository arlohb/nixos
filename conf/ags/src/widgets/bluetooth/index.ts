const bluetooth = await Service.import("bluetooth");

export default (orientation: "H" | "V") => Widget.EventBox({
    onPrimaryClick: () => Utils.execAsync("blueberry"),
    child: Widget.Box({
        className: "widget bluetooth",
        orientation: orientation === "H" ? 0 : 1,
        children: orientation === "H"
            ? [
                Widget.Label(" "),
                Widget.Label({
                    label: bluetooth
                        .bind("connected_devices")
                        .as(devices => devices
                            .map(device => `${(device.name as string).clip(10)} ${device.battery_percentage}%`)
                            .join(", "))
                })
            ]
            : bluetooth.bind("connected_devices").as(devices => [
                Widget.Label(" "),
                ...devices.flatMap(device => [
                    Widget.Label(`${device.name}`),
                    Widget.Label(`${device.battery_percentage}%`),
                ]),
            ])
        ,
    }),
});

