#!/usr/bin/env fish

if test (count $argv) = 0
    set initial $(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
    set v $(math 1 - $initial)
else
    set v $argv
end

function toggle
    hyprctl keyword $argv[1] $v
end

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

if test $v = 0
    change_timer nextcloud-sync 10m
else
    change_timer nextcloud-sync 2m
end

