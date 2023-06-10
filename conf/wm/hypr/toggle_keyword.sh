#!/usr/bin/env fish

set initial $(hyprctl getoption $argv | awk 'NR==2{print $2}')

set new $(math 1 - $initial)

hyprctl keyword $argv $new
