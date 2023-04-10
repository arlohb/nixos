#!/usr/bin/env bash

if [ "$(cat /etc/hostname)" == "arlo-nix" ]; then
    hyprctl --batch "\
        keyword monitor DVI-D-2, preferred, 0x0, 1 ;\
        keyword monitor HDMI-A-1, preferred, 1920x0, 1 ;\
        keyword monitor DVI-D-1, preferred, 4480x0, 1, transform, 1 ;\
        keyword wsbind 1, DVI-D-2 ;\
        keyword wsbind 2, DVI-D-2 ;\
        keyword wsbind 3, HDMI-A-1 ;\
        keyword wsbind 4, HDMI-A-1 ;\
        keyword wsbind 5, DVI-D-1 ;\
        keyword wsbind 6, DVI-D-1 ;\
    "
else
    hyprctl keyword monitor eDP-1, preferred, auto, 1

    eww open bar
fi

swww init
sleep 0.1

if [ "$(cat /etc/hostname)" == "arlo-nix" ]; then
    swww img -o DVI-D-2 /etc/nixos/backgrounds/city.jpg
    swww img -o HDMI-A-1 /etc/nixos/backgrounds/astronaut.jpg
    swww img -o DVI-D-1 /etc/nixos/backgrounds/mountains.jpg
else
    swww img -o eDP-1 /etc/nixos/backgrounds/rainbow-l.jpg
fi
