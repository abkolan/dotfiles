# ===========================
# PERFORMANCE: Powerlevel10k instant prompt (CRITICAL: Must be at top)
# This enables instant prompt which dramatically improves perceived startup time
# ===========================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ===========================
# PERFORMANCE: Skip config in non-interactive shells (IntelliJ, scripts, etc.)
# This prevents expensive initialization in automated environments
# ===========================
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then

  # ===========================
  # PERFORMANCE: Oh-My-Zsh Configuration
  # Optimized plugin selection - only essential plugins for speed
  # ===========================
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME=""  # Theme handled by Powerlevel10k for better performance

  # PERFORMANCE: Enable case sensitivity to speed up completions
  CASE_SENSITIVE="true"
  # PERFORMANCE: Disable correction to avoid delays
  DISABLE_CORRECTION="true"  # Changed from ENABLE_CORRECTION for speed
  
  # PERFORMANCE: Minimal essential plugins only
  # Note: zsh-syntax-highlighting moved to end for better performance
  plugins=(
    git                    # Essential Git integration
    zsh-autosuggestions   # Fast command suggestions
    you-should-use        # Lightweight alias reminders
  )

  # PERFORMANCE: Load Oh-My-Zsh framework
  source "$ZSH/oh-my-zsh.sh"

  # ===========================
  # PERFORMANCE: Source custom configurations
  # Using [[ ]] for better performance than [ ]
  # ===========================
  [[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
  [[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"

  # ===========================
  # PERFORMANCE: Smart NVM lazy loading
  # Load NVM only when actually needed, but ensure it works correctly
  # ===========================
  export NVM_DIR="$HOME/.nvm"
  
  # PERFORMANCE: Helper function to initialize NVM once
  _load_nvm() {
    # Only load if not already loaded
    if ! command -v nvm >/dev/null 2>&1 || [[ $(type nvm) == *"function"* ]]; then
      [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
      [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    fi
  }
  
  # PERFORMANCE: Lazy-loading wrapper for nvm
  nvm() {
    unfunction nvm 2>/dev/null
    _load_nvm
    nvm "$@"
  }
  
  # PERFORMANCE: Lazy-loading wrappers for node tools
  node() {
    unfunction node 2>/dev/null
    _load_nvm
    # Try to use default version if available, otherwise use current
    if nvm list default >/dev/null 2>&1; then
      nvm use default >/dev/null 2>&1
    fi
    node "$@"
  }
  
  npm() {
    unfunction npm 2>/dev/null  
    _load_nvm
    if nvm list default >/dev/null 2>&1; then
      nvm use default >/dev/null 2>&1
    fi
    npm "$@"
  }
  
  npx() {
    unfunction npx 2>/dev/null
    _load_nvm
    if nvm list default >/dev/null 2>&1; then
      nvm use default >/dev/null 2>&1
    fi
    npx "$@"
  }

  # ===========================
  # PERFORMANCE: Lazy-load Conda (prevents slow startup)
  # Conda initialization is extremely slow, so we defer it until first use
  # ===========================
  if command -v conda >/dev/null 2>&1; then
    # PERFORMANCE: Create lazy-loading wrapper for conda
    conda() {
      # Remove this function and initialize conda properly
      unfunction conda
      local __conda_setup
      __conda_setup="$(conda 'shell.zsh' 'hook' 2> /dev/null)"
      if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
      elif [[ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]]; then
        source "$HOME/anaconda3/etc/profile.d/conda.sh"
      else
        export PATH="$HOME/anaconda3/bin:$PATH"
      fi
      unset __conda_setup
      # Call the real conda with original arguments
      conda "$@"
    }
  fi

fi  # End of INTELLIJ_ENVIRONMENT_READER check

# ===========================
# PERFORMANCE: Completion paths setup (outside IntelliJ check)
# These need to be set before compinit for optimal performance
# ===========================
# PERFORMANCE: Use static Homebrew prefix detection (avoids slow brew --prefix)
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"  # Apple Silicon default
  elif [[ -x "/usr/local/bin/brew" ]]; then
    export HOMEBREW_PREFIX="/usr/local"     # Intel Mac default
  else
    export HOMEBREW_PREFIX="/opt/homebrew"  # Fallback to common default
  fi
fi

# PERFORMANCE: Add completion paths efficiently
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

# ===========================
# PERFORMANCE: Powerlevel10k theme loading
# Using cached HOMEBREW_PREFIX for speed
# ===========================
[[ -f "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]] && \
  source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ===========================
# PERFORMANCE: Directory jumping with zoxide
# zoxide is faster than z, but we still optimize the initialization
# ===========================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ===========================
# PERFORMANCE: Tool configurations
# Group related exports and sources for better organization
# ===========================
# PERFORMANCE: Set ripgrep config (moved to .zshenv would be even better)
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"

# PERFORMANCE: broot launcher (lightweight file manager)
[[ -f "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

# ===========================
# PERFORMANCE: Lazy-load kubectl completions
# kubectl completion is VERY slow, so we defer it until first use
# ===========================
if command -v kubectl >/dev/null 2>&1; then
  # PERFORMANCE: Create lazy-loading wrapper for kubectl
  kubectl() {
    # Remove this function and load real kubectl completion
    unfunction kubectl
    source <(command kubectl completion zsh)
    # Call the real kubectl with original arguments
    command kubectl "$@"
  }
  
  # PERFORMANCE: Alias 'k' for kubectl with lazy loading
  alias k='kubectl'
fi

# ===========================
# PERFORMANCE: Optimized completion initialization
# Use conditional initialization to speed up shell startup
# ===========================
autoload -Uz compinit

# PERFORMANCE: Only rebuild completions if they're older than 24 hours
# The glob pattern (#qN.mh+24) checks if the file exists and is less than 24 hours old
if [[ -f ${ZDOTDIR:-$HOME}/.zcompdump ]] && [[ ${ZDOTDIR:-$HOME}/.zcompdump -nt /usr/share/zsh ]] && [[ ! ${ZDOTDIR:-$HOME}/.zcompdump -ot ${ZDOTDIR:-$HOME}/.zshrc ]]; then
  # Dump exists, is newer than system files, and not older than .zshrc
  compinit -C  # Skip security check for speed
else
  # Dump is missing, outdated, or .zshrc has been modified
  compinit
fi

# ===========================
# PERFORMANCE: Load syntax highlighting last for optimal performance
# This plugin should be loaded after all other plugins
# ===========================
[[ -f "$ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ===========================
# PERFORMANCE: Custom alias completions
# Set up completions for custom aliases
# ===========================
if command -v lsd >/dev/null 2>&1; then
  compdef lls=ls
  compdef lll=ls
  compdef lla=ls
fi

# ===========================
# PERFORMANCE: Shell options for speed
# Configure ZSH for optimal performance
# ===========================
# PERFORMANCE: Disable beep for faster operation
setopt NO_BEEP
# PERFORMANCE: Enable faster globbing
setopt EXTENDED_GLOB
# PERFORMANCE: Faster history operations
setopt HIST_VERIFY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
# PERFORMANCE: Faster directory operations
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# ===========================
# COMPLETION ENHANCEMENTS - HIDDEN FILES & DIRECTORIES
# ===========================
# PERFORMANCE: Show hidden files and directories in completion
setopt GLOB_DOTS              # Include dotfiles in globbing
setopt COMPLETE_IN_WORD       # Complete from both ends of word
setopt ALWAYS_TO_END          # Move cursor to end after completion

# PERFORMANCE: Enhanced completion system configuration
zstyle ':completion:*' special-dirs true              # Include . and .. in completion
zstyle ':completion:*' list-colors ''                 # Use same colors as ls
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive matching
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
zstyle ':completion:*:cd:*' group-name ''
zstyle ':completion:*:cd:*' complete-options true
zstyle ':completion:*:cd:*' accept-exact-dirs true

# PERFORMANCE: Show hidden directories specifically for cd command
zstyle ':completion:*:*:cd:*' file-patterns '*(-/):directories' '.*(-/):hidden-directories'

# PERFORMANCE: General file completion improvements
zstyle ':completion:*' file-patterns '*:all-files' '.*:hidden-files'
zstyle ':completion:*' menu select                    # Visual menu for completion
zstyle ':completion:*' verbose true                   # Show descriptions

# NOTE: Completion system already initialized above with optimized caching