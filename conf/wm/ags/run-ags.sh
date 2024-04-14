#!/usr/bin/env bash

function run {
    ags --quit
    ags -c /etc/nixos/conf/wm/ags/config.js &
}

run

while inotifywait -qq -e modify /etc/nixos/conf/wm/ags/src; do
    run
done

