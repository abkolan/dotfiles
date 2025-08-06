#!/bin/bash
# Wrapper script for Claude Code to ensure node is in PATH

# Source nvm if available
[ -s "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh"

# Set explicit node path as fallback
export PATH="/Users/ab/.nvm/versions/node/v22.4.0/bin:$PATH"

# Execute claude with all arguments
exec /Users/ab/.nvm/versions/node/v22.4.0/bin/claude "$@"