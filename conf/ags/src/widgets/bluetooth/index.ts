import type { BluetoothDevice } from "types/service/bluetooth";

const bluetooth = await Service.import("bluetooth");

const deviceToString = (device: BluetoothDevice, clip: number) =>
    `${(device.name as string).clip(clip)} ${device.battery_percentage}%`;

const devicesToString = (devices: BluetoothDevice[], clip: number) => devices
    .map(device => deviceToString(device, clip))
    .join(", ");

// TODO: Improve when V
export default (orientation: "H" | "V") => Widget.EventBox({
    onPrimaryClick: () => Utils.execAsync("blueberry"),
    child: Widget.Box({
        className: "widget bluetooth",
        orientation: orientation === "H" ? 0 : 1,
        children: [
            Widget.Label(" "),
            Widget.Label({
                label: bluetooth
                   .bind("connected_devices")
                   .transform(devices => `${devicesToString(devices, orientation === "H" ? 10 : 5)}`)
            }),
        ],
    }),
});

