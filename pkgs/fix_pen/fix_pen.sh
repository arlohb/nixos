#!/usr/bin/env bash

pkill ydotoold
ydotoold &
 
libinput debug-events | while read -r event; do
    echo $event | grep "event17.*TABLET_TOOL_TIP.*down" > /dev/null
    if [[ $? == 0 ]]; then
        ydotool click 0xC0
    fi
done

