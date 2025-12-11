#!/bin/bash
# ~/.config/wofi/wofi-launcher.sh

# Brave command (adjust if needed)
BRAVE_CMD="flatpak run com.brave.Browser"

# Get input from wofi
input=$(wofi --show dmenu --prompt "Run, Search, or Calculate..." --lines 0)

# Exit if nothing entered
[ -z "$input" ] && exit

# Check if input is a mathematical expression
if echo "$input" | grep -qE '^[0-9\+\-\*/\(\)\.\^ ]+$'; then
    # Calculate using bc
    result=$(echo "$input" | bc -l 2>/dev/null)
    if [ $? -eq 0 ]; then
        # Show result and copy to clipboard
        echo "$result" | wl-copy
        notify-send "Calculator" "Result: $result (copied to clipboard)"
        exit
    fi
fi

# Check for search prefix
if [[ "$input" == ?* ]] || [[ "$input" == google* ]] || [[ "$input" == search* ]]; then
    # Remove prefix if exists
    query="${input#?}"
    query="${query#google}"
    query="${query#search}"
    query="${query# }"
    
    # Open browser with search - reuse existing Brave instance
    search_url="https://www.google.com/search?q=$(echo "$query" | jq -sRr @uri)"
    if pgrep -f "com.brave.Browser" > /dev/null; then
        $BRAVE_CMD "$search_url" &
    else
        $BRAVE_CMD --new-window "$search_url" &
    fi
    exit
fi

# Check if it's a URL
if [[ "$input" =~ ^https?:// ]]; then
    if pgrep -f "com.brave.Browser" > /dev/null; then
        $BRAVE_CMD "$input" &
    else
        $BRAVE_CMD --new-window "$input" &
    fi
    exit
fi

# Check if it's a command
if command -v "$input" &> /dev/null; then
    $input &
    exit
fi

# Otherwise, treat as a search query
search_url="https://www.google.com/search?q=$(echo "$input" | jq -sRr @uri)"
if pgrep -x brave > /dev/null; then
    brave "$search_url" &
else
    brave --new-window "$search_url" &
fi
