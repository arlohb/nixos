#!/usr/bin/env bash

# Start ags in background
# So it doesn't delay startup
sh -c " \
    cd /etc/nixos/conf/ags; \
    nix run .#gen-types; \
    nix run . & \
" &

pkill bar
bar &

swww-daemon &
sleep 0.1

if [ $(hostname) == "arlo-nix" ]; then
    swww img -o DP-1 /etc/nixos/backgrounds/cp2077/Pixel3.gif
    swww img -o HDMI-A-1 /etc/nixos/backgrounds/cp2077/Pixel3.gif
    swww img -o DP-2 /etc/nixos/backgrounds/cp2077/Pixel2.png
elif [ $(hostname) == "arlo-laptop2" ]; then
    swww img -o eDP-1 /etc/nixos/backgrounds/rainbow-l.jpg
    swww img -o HDMI-A-1 /etc/nixos/backgrounds/cp2077/Far4.png
    swww img -o DP-1 /etc/nixos/backgrounds/disco_elysium/title_screen.jpeg
fi
