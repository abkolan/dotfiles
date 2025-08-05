# ===========================
# PERFORMANCE: Environment Variables (.zshenv)
# This file is sourced for ALL zsh invocations (login, non-login, scripts)
# Keep only essential environment variables here for optimal performance
# ===========================

# PERFORMANCE: Workspace configuration
export WORKSPACE="$HOME/Developer/repos"

# PERFORMANCE: Homebrew configuration  
export HOMEBREW_AUTO_UPDATE_SECS=86400
# PERFORMANCE: Disable Homebrew analytics for faster operations
export HOMEBREW_NO_ANALYTICS=1
# PERFORMANCE: Use Homebrew's faster installation method
export HOMEBREW_NO_AUTO_UPDATE=1

# PERFORMANCE: Disable Oh My Zsh auto-update prompts for faster startup
export DISABLE_UPDATE_PROMPT=true
export DISABLE_AUTO_UPDATE=true

# PERFORMANCE: Default editors (essential for many tools)
export EDITOR=nvim
export VISUAL=nvim

# PERFORMANCE: Locale settings (required by many tools)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# PERFORMANCE: Essential tool configurations
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"

# PERFORMANCE: Prevent PATH duplicates (critical for performance)
typeset -U PATH

# ===========================
# PERFORMANCE: Optimized PATH Construction
# Build PATH efficiently with minimal external calls
# ===========================

# PERFORMANCE: Build PATH in a single operation to minimize overhead
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS: Include all paths in one assignment
  PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/System/Cryptexes/App/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin"
else
  # Linux/other: Standard paths only
  PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
fi

# PERFORMANCE: Add Go PATH with error handling and caching
if command -v go >/dev/null 2>&1; then
  # Cache GOPATH to avoid repeated calls
  export GOPATH="${GOPATH:-$(go env GOPATH 2>/dev/null || echo "$HOME/go")}"
  PATH="$PATH:$GOPATH/bin"
fi

# PERFORMANCE: Source Cargo environment if it exists
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# ===========================
# FZF CONFIGURATION - PERFORMANCE OPTIMIZED
# ===========================
# Default command uses fd for better performance and respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Default options with optimized preview and keybindings
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview-window=right:60% --bind "ctrl-/:change-preview-window(down|hidden|)" --bind ctrl-u:preview-page-up --bind ctrl-d:preview-page-down'

# Ctrl+T command for file selection
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'

# Alt+C command for directory selection
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS='--preview "eza --tree --level=2 --color=always {} 2>/dev/null || ls -la {}"'

# Ctrl+R command for history search
export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window down:3:hidden:wrap --bind "ctrl-/:toggle-preview"'

# PERFORMANCE: Export the constructed PATH
export PATH
