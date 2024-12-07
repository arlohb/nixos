#!/usr/bin/env bash

geom=$(slurp)

# Save to home
grim -g "$geom"
# Copy to clipboard
grim -g "$geom" - | wl-copy

