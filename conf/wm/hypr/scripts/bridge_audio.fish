#!/usr/bin/env fish

# If no args passed in
if test (count $argv) = 0
    # Default to headphones
    set out "bluez_output.F4_4E_FD_00_15_C9.1:playback_"
else
    switch $argv[1]
        case headphones
            set out "bluez_output.F4_4E_FD_00_15_C9.1:playback_"
        case speaker
            set out "bluez_output.08_EB_ED_76_44_32.1:playback_"
        case "*"
            set out $argv[1]
    end
end

pw-link alsa_input.pci-0000_0b_00.3.analog-stereo:capture_FL \
    "$out"FL

pw-link alsa_input.pci-0000_0b_00.3.analog-stereo:capture_FR \
    "$out"FR

