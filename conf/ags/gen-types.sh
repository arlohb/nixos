#!/usr/bin/env bash

BIN=$(which ags)
STORE=$(dirname $(dirname $BIN))
TYPES="$STORE/share/com.github.Aylur.ags/types"

rm -f types

ln -s $TYPES types

echo "Types symlink created"

