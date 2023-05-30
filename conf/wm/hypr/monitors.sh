#!/usr/bin/env bash

if [ "$(cat /etc/hostname)" == "arlo-laptop2" ]; then
    eww open laptop-bar
else
    eww open pc-bar
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
