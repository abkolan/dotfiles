#!/bin/bash

# Script to toggle the Dock position between bottom and right on Mac
# Get the current Dock position
current_position=$(defaults read com.apple.dock orientation)

# Toggle Dock position between bottom and right
if [ "$current_position" = "bottom" ]; then
    echo "Switching Dock to the right..."
    defaults write com.apple.dock orientation -string right
else
    echo "Switching Dock to the bottom..."
    defaults write com.apple.dock orientation -string bottom
fi

# Restart the Dock to apply changes
killall Dock

echo "Dock position toggled successfully."