#!/usr/bin/env bash

function run {
    ags --quit
    ags -c ./config.js &
}

run

while inotifywait -qq -e modify src; do
    run
done

