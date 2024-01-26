#!/usr/bin/env bash

normal_shown=false
critical_shown=false

while true; do
    # free's used column doesn't account for everything
    # So I calculate it from the available and total
    total_ram=$(free -b | awk '/Mem:/{print $2}')
    available_ram=$(free -b | awk '/Mem:/{print $7}')
    used_ram_b=$((total_ram - available_ram))
    used_ram=$(($used_ram_b / 1024 / 1024 / 1024))

    # For debugging
    # read -p "RAM: " used_ram

    if ((used_ram >= 20)); then
        if [ "$critical_shown" = false ]; then
            dunstify -u critical "20G of RAM used!" "Bad things are going to happen..."
            critical_shown=true
        fi
    elif ((used_ram >= 16)); then
        critical_shown=false
        if [ "$normal_shown" = false ]; then
            dunstify -u normal "16G of RAM used!" "Might be fine, keep a watch out"
            normal_shown=true
        fi
    else
        normal_shown=false
        critical_shown=false
    fi

    sleep 1
done
