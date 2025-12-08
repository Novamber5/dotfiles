#!/bin/bash

# Get mic mute status
MUTED=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -o "yes\|no")

if [ "$MUTED" = "yes" ]; then
    echo '{"text":" Muted","class":"muted"}'
else
    echo '{"text":" ","class":"unmuted"}'
fi
