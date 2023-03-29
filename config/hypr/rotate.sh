#!/usr/bin/env bash

eww close bar

hyprctl --batch "\
    keyword monitor eDP-1, transform, $1; \
    keyword input:touchdevice:transform $1"

sleep 0.1

if [[ $1 == 0 ]] then
    swww img -o eDP-1 /etc/nixos/backgrounds/rainbow-l.jpg
else
    swww img -o eDP-1 /etc/nixos/backgrounds/rainbow-p.jpg
fi

eww open bar
