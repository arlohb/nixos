#!/usr/bin/env bash

if [ "$(cat /etc/hostname)" == "arlo-laptop2" ]; then
    eww open laptop-bar
else
    eww open pc-bar
fi

swww init
sleep 0.1

if [ "$(cat /etc/hostname)" == "arlo-nix" ]; then
    swww img -o DP-3 /etc/nixos/backgrounds/disco_elysium/cryptid.jpg
    # swww img -o HDMI-A-1 /etc/nixos/backgrounds/disco_elysium/title_screen.jpeg
    swww img -o DP-2 /etc/nixos/backgrounds/disco_elysium/whirling_in_rags.jpg
else
    swww img -o eDP-1 /etc/nixos/backgrounds/rainbow-l.jpg
fi
