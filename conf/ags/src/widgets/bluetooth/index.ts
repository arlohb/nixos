import type { BluetoothDevice } from "types/service/bluetooth";

const bluetooth = await Service.import("bluetooth");

const deviceToString = (device: BluetoothDevice) =>
    `${(device.name as string).clip(10)} ${device.battery_percentage}%`;

const devicesToString = (devices: BluetoothDevice[]) => devices
    .map(deviceToString)
    .join(", ");

export default () => Widget.EventBox({
    onPrimaryClick: () => Utils.execAsync("blueberry"),
    child: Widget.Box({
        className: "widget bluetooth",
        children: [
            Widget.Label({
                label: bluetooth
                   .bind("connected_devices")
                   .transform(devices => `   ${devicesToString(devices)}`)
            }),
        ],
    }),
});

