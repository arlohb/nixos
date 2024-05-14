import type { BluetoothDevice } from "types/service/bluetooth";

const bluetooth = await Service.import("bluetooth");

const deviceToString = (device: BluetoothDevice) =>
    `${(device.name as string).clip(10)} ${device.battery_percentage}%`;

const devicesToString = (devices: BluetoothDevice[]) => devices
    .map(deviceToString)
    .join(", ");

export default () => Widget.Box({
    className: "widget bluetooth",
    hpack: "fill",
    vpack: "fill",
    children: [
        Widget.Label({
            label: bluetooth
                .bind("connected_devices")
                .transform(devices => `   ${devicesToString(devices)}`)
        }),
    ],
});

