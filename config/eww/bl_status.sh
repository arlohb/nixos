#!/usr/bin/env bash

# Taken from rofi-bluetooth
# https://github.com/nickclyde/rofi-bluetooth/blob/master/rofi-bluetooth

power_on() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        return 0
    else
        return 1
    fi
}

device_connected() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Connected: yes"; then
        return 0
    else
        return 1
    fi
}

get_battery() {
    # Replace : with _
    device=$(echo $1 | tr ':' '_')
    path="/org/bluez/hci0/dev_$device"
    echo $(dbus-send --print-reply=literal \
        --system --dest=org.bluez \
        $path \
        org.freedesktop.DBus.Properties.Get string:"org.bluez.Battery1" string:"Percentage" \
        | tr -s ' ' \
        | cut -d ' ' -f 4)
}

print_battery() {
    battery=$(get_battery $device)

    printf " "

    if [ $battery -lt 15 ]; then
        printf "󰤾 "
    elif [ $battery -lt 25 ]; then
        printf "󰤿 "
    elif [ $battery -lt 35 ]; then
        printf "󰥀 "
    elif [ $battery -lt 45 ]; then
        printf "󰥁 "
    elif [ $battery -lt 55 ]; then
        printf "󰥂 "
    elif [ $battery -lt 65 ]; then
        printf "󰥃 "
    elif [ $battery -lt 75 ]; then
        printf "󰥄 "
    elif [ $battery -lt 85 ]; then
        printf "󰥅 "
    elif [ $battery -lt 95 ]; then
        printf "󰥆 "
    else
        printf "󰥈 "
    fi

    printf " %d%%" $battery
}

if power_on; then
    printf ' '

    mapfile -t paired_devices < <(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    counter=0

    for device in "${paired_devices[@]}"; do
        if device_connected "$device"; then
            device_alias=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)

            if [ $counter -gt 0 ]; then
                printf ", %s" "$device_alias"
            else
                printf " %s" "$device_alias"
            fi

            ((counter++))

            print_battery $device
        fi
    done
else
    echo ""
fi

