#!/usr/bin/env bash

function run {
    ags --quit
    ags -c /etc/nixos/conf/ags/config.js &
}

run

while inotifywait --recursive -qq --event modify /etc/nixos/conf/ags/src; do
    run
done

