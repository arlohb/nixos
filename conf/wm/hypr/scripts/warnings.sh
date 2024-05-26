#!/usr/bin/env bash

# Look back to commit 9f57c5c to see how this worked with multiple levels of warning
# For now I've decided I just need 1

shown=false

while true; do
    # free's used column doesn't account for everything
    # So I calculate it from the available and total
    total_ram=$(free -b | awk '/Mem:/{print $2}')
    available_ram=$(free -b | awk '/Mem:/{print $7}')
    used_ram_b=$((total_ram - available_ram))
    used_ram=$(($used_ram_b / 1024 / 1024 / 1024))

    # For debugging
    # read -p "RAM: " used_ram

    if ((used_ram >= 22)); then
        if [ "$shown" = false ]; then
            dunstify -u critical "22G of RAM used!" "Bad things are going to happen..."
            shown=true
        fi
    else
        shown=false
    fi

    sleep 1
done
