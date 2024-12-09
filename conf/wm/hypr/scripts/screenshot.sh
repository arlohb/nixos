#!/usr/bin/env bash

# TODO: Look into hyprshot

geom=$(slurp)

# Save to home
grim -g "$geom"
# Copy to clipboard
grim -g "$geom" - | wl-copy

