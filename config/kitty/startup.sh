#!/bin/bash
# Kitty startup script
if [[ "$SHLVL" -eq 1 ]]; then
    ~/.local/bin/ffetch
fi
exec $SHELL
