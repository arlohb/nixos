#!/usr/bin/env fish

function get_vol
    math "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100"
end

function notify
    dunstify Volume \
        # The tag means the notification is replaced
        -h "string:x-dunst-stack-tag:volume" \
        -h "int:value:$argv[1]"
end

if test (count $argv) -eq 0
    echo -e "Usage: volume [cmd]\n"
    echo -e "Commands:"
    echo -e "  get"
    echo -e "  inc [+/-] [step]"
    echo -e "  set [vol] [step]"
    echo -e "  togglemute"
    echo -e ""
    exit
end

set cmd $argv[1]

switch $cmd
case get
    get_vol
case inc
    set op $argv[2]
    set step $argv[3]

    set vol $(get_vol)
    # Floor to multiple of step
    set vol $(math "$vol - ($vol % $step)")
    # Calculate new volume
    set vol $(math "$vol $op $step")

    # Unmute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    # Set new volume
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ {$vol}%

    notify $vol
case set
    set vol $argv[2]
    set step $argv[3]

    # Floor to multiple of step
    set vol $(math "$vol - ($vol % $step)")

    # Unmute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    # Set new volume
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ {$vol}%

    notify $vol
case togglemute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    set is_muted $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f3)

    # Is string length non-zero
    if test -n $is_muted
        echo "Is muted"
        notify 0
    else
        echo "Not muted"
        notify $(get_vol)
    end
end

