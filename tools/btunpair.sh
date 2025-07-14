#!/usr/bin/env bash

command -v blueutil >/dev/null || {
    echo "blueutil not found; run 'make tool-blueutil' to install it"
    exit 127
}

devices=($(blueutil --paired | grep -E 'Magic (Trackpad|Keyboard)' | cut -f2 -d' ' | tr -d ',' | xargs))

for d in "${devices[@]}"; do
    blueutil --unpair $d
done
