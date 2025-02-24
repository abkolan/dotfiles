# Set Workspace related stuff 
export WORKSPACE="$HOME/Developer/repos"


# Set Homebrew auto update
export HOMEBREW_AUTO_UPDATE_SECS=86400

# Default Editor
export EDITOR=nvim
export VISUAL=nvim

# Language & Locale Settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Avoid Duplicate Entries in PATH
typeset -U PATH

# Set Homebrew Path (for macOS users)
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi


