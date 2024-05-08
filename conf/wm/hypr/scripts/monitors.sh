#!/usr/bin/env bash

if [ "$(cat /etc/hostname)" == "arlo-laptop2" ]; then
    eww open laptop-bar
else
    cd /etc/nixos/conf/ags
    nix run .#gen-types
    nix run . &
fi

swww init
sleep 0.1

if [ "$(cat /etc/hostname)" == "arlo-nix" ]; then
    swww img -o DP-1 /etc/nixos/backgrounds/cp2077/Pixel3.gif
    swww img -o HDMI-A-1 /etc/nixos/backgrounds/cp2077/Pixel3.gif
    swww img -o DP-2 /etc/nixos/backgrounds/cp2077/Pixel2.png
else
    swww img -o eDP-1 /etc/nixos/backgrounds/rainbow-l.jpg
fi
