#!/usr/bin/env fish

set main_x (hyprctl monitors -j | jq ".[] | select([.width == 2560] | any) | .x")

if [ $main_x = 1920 ]
    dunstify "Enabling mouse lock"

    hyprctl keyword monitor HDMI-A-1, preferred, 10000x0, 1
    hyprctl keyword monitor DP-2, preferred, 20000x0, 1, transform, 1
else
    dunstify "Disabling mouse lock"

    hyprctl keyword monitor HDMI-A-1, preferred, 1920x0, 1
    hyprctl keyword monitor DP-2, preferred, (math 1920+2560)x0, 1, transform, 1
end

