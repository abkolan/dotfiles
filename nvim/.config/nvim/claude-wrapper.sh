#!/bin/bash
# Wrapper script for Claude Code to ensure node is in PATH

# Source nvm if available
[ -s "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh"

# Try to find the latest node version dynamically
if [ -d "$HOME/.nvm/versions/node" ]; then
    # Get the latest node version
    LATEST_NODE=$(ls -v "$HOME/.nvm/versions/node" | tail -1)
    if [ -n "$LATEST_NODE" ]; then
        export PATH="$HOME/.nvm/versions/node/$LATEST_NODE/bin:$PATH"
    fi
fi

# Execute claude with all arguments (use which to find it dynamically)
if command -v claude &> /dev/null; then
    exec claude "$@"
else
    echo "Error: claude command not found in PATH" >&2
    exit 1
fi