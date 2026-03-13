#!/usr/bin/env bash

pkill gjs
bar &

awww-daemon &
sleep 0.1

if [ $(hostname) == "arlo-nix" ]; then
    awww img -o DP-1 /etc/nixos/backgrounds/cp2077/Pixel3.gif
    awww img -o HDMI-A-1 /etc/nixos/backgrounds/cp2077/Pixel3.gif
    awww img -o DP-2 /etc/nixos/backgrounds/cp2077/Pixel2.png
elif [ $(hostname) == "arlo-laptop2" ]; then
    awww img -o eDP-1 /etc/nixos/backgrounds/rainbow-l.jpg
    awww img -o HDMI-A-1 /etc/nixos/backgrounds/cp2077/Far4.png
    awww img -o DP-1 /etc/nixos/backgrounds/disco_elysium/title_screen.jpeg
fi
