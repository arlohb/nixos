#!/usr/bin/env fish

pw-link alsa_input.pci-0000_0b_00.3.analog-stereo:capture_FL \
    bluez_output.F4_4E_FD_00_15_C9.1:playback_FL

pw-link alsa_input.pci-0000_0b_00.3.analog-stereo:capture_FR \
    bluez_output.F4_4E_FD_00_15_C9.1:playback_FR

