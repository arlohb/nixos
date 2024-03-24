#!/usr/bin/env fish

# If no args passed in
if test (count $argv) = 0
    # Default to headphones
    set out "NC75 Pro:playback_"
else
    switch $argv[1]
        case headphones
            set out "NC75 Pro:playback_"
        case speaker
            set out "SoundCore 2:playback_"
        case "*"
            set out $argv[1]
    end
end

pw-link "ALC887-VD Analog:capture_FL" \
    "$out"FL

pw-link "ALC887-VD Analog:capture_FR" \
    "$out"FR

