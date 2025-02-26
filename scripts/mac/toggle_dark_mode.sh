#!/bin/bash

# Check current mode and toggle
current_mode=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

if [ "$current_mode" = "Dark" ]; then
    # Switch to Light mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
    echo "Switched to Light mode"
else
    # Switch to Dark mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
    echo "Switched to Dark mode"
fi