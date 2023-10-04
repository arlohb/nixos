#!/usr/bin/env bash

function set_background {
    MONITOR=$(swww query | grep -v eDP-1 | cut -d: -f1)
    swww img -o $MONITOR /etc/nixos/backgrounds/knight.png
}

function handle {
    if [[ ${1:0:12} == "monitoradded" ]]; then
        # Wait for swww to see monitor
        sleep 1
        set_background
    fi
}

# Have to wait for swww init to be ran
sleep 1

set_background

socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock \
    | while read line; do
        handle $line;
    done

