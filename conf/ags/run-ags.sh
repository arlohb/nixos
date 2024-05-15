#!/usr/bin/env bash

# Kill ags
pkill --exact ags
# Kill all run-ags except this process
pgrep run-ags | grep -v $$ | xargs -r kill

function run {
    ags --quit
    ags -c /etc/nixos/conf/ags/config.js &
}

run

while inotifywait --recursive -qq --event modify /etc/nixos/conf/ags/src; do
    run
done

