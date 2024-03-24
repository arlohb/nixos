#!/usr/bin/env fish

# Allows calling outside of hyprland
if not set -q HYPRLAND_INSTANCE_SIGNATURE
    # -x makes it a proper env var
    # Passing it to child processes
    set -x HYPRLAND_INSTANCE_SIGNATURE $(hyprctl instances \
        | awk 'NR==1{print substr($2, 1, length($2)-1)}')
end

# If 0 or 1 not passed in
if test (count $argv) = 0
    # Toggle based on animations:enabled
    set initial $(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
    set v $(math 1 - $initial)
else
    set v $argv
end

# Set a hyprland bool value
function toggle
    hyprctl keyword $argv[1] $v
end

# Set a hyprland value from two values based on bool
function keyword
    if test $v = 0
        set u $argv[2]
    else
        set u $argv[3]
    end

    hyprctl keyword $argv[1] $u
end

keyword general:gaps_in 0 6
keyword general:gaps_out 0 12
keyword decoration:rounding 0 5
toggle animations:enabled
toggle decoration:blur:enabled

# Sync nextcloud less often
if test $v = 0
    change_timer nextcloud-sync 10m
else
    change_timer nextcloud-sync 2m
end

