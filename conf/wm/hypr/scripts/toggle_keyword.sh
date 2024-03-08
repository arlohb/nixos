#!/usr/bin/env fish

set initial $(hyprctl getoption $argv | awk 'NR==2{print $2}')

# False and true are commands in fish
# Returning statuses 1 and 0 respectively
# Effectively inverting a bool
$initial

set new $status

hyprctl keyword $argv $new
