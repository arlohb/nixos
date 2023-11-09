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

if power_on; then
    printf ' '

    mapfile -t paired_devices < <(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    counter=0

    last_device=""

    for device in "${paired_devices[@]}"; do
        if device_connected "$device"; then
            device_alias=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)

            if [ $counter -gt 0 ]; then
                printf ", %s" "$device_alias"
            else
                printf " %s" "$device_alias"
            fi

            ((counter++))

            last_device=$device
        fi
    done

    # Battery seems to return one value for all devices
    # So just do it for the last device
    # And let the user figure out which one it is
    if [ -n "$last_device" ]; then
        battery=$(get_battery $last_device)

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
    fi

    printf "\n"
else
    echo ""
fi

