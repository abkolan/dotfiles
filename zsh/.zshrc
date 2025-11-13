# ===========================
# OPTIMIZED ZINIT-ONLY ZSH CONFIGURATION
# Target: < 50ms startup time
# ===========================

# Enable Powerlevel10k instant prompt (MUST be first)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Skip all initialization in non-interactive environments
[[ -o interactive ]] || return
[ -n "$INTELLIJ_ENVIRONMENT_READER" ] && return

# ===========================
# ZINIT INSTALLATION & SETUP
# ===========================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Auto-install Zinit if not present
if [[ ! -d "$ZINIT_HOME" ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZINIT%F{220} (zdharma-continuum/zinit)…%f"
  command mkdir -p "$(dirname $ZINIT_HOME)"
  command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# ===========================
# ZINIT OPTIMIZATIONS
# ===========================
zstyle ':zinit:*' use-cache yes
zstyle ':zinit:*' cache-dir ~/.cache/zinit

# ===========================
# THEME: Powerlevel10k (optimized loading)
# ===========================
zinit ice depth=1 atload'[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'
zinit light romkatv/powerlevel10k

# ===========================
# TURBO MODE PLUGINS (loaded after prompt appears)
# Using wait'0a', '0b', '0c' for staged loading
# ===========================

# Git support - load immediately after prompt
zinit ice wait'0a' lucid
zinit snippet OMZP::git

# Fast syntax highlighting - load after git (avoid double compinit)
zinit ice wait'0b' lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions - load with syntax highlighting
zinit ice wait'0b' lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

# History substring search - load slightly later
zinit ice wait'0c' lucid atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

# Additional completions - load after 1 second
zinit ice wait'1' lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# FZF tab completion - load after 1 second
zinit ice wait'1' lucid
zinit light Aloxaf/fzf-tab

# ===========================
# NODE.JS LAZY LOADING
# ===========================
export NVM_DIR="$HOME/.nvm"
export ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

# Source lazy loading functions for Node.js tools
# This provides lazy wrappers for npm, node, npx, and global packages
[[ -f "$HOME/.zsh_functions_lazy" ]] && source "$HOME/.zsh_functions_lazy"

# ===========================
# CONDA LAZY LOADING
# ===========================
conda() {
  unfunction conda 2>/dev/null
  __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  [ $? -eq 0 ] && eval "$__conda_setup" || export PATH="$HOME/miniconda3/bin:$PATH"
  unset __conda_setup
  conda "$@"
}

# ===========================
# BROOT LAUNCHER
# ===========================
[[ -f "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

# ===========================
# KUBECTL LAZY LOADING
# ===========================
if command -v kubectl >/dev/null 2>&1; then
  kubectl() {
    unfunction kubectl
    source <(command kubectl completion zsh)
    command kubectl "$@"
  }
fi

# ===========================
# ENVIRONMENT SETUP
# ===========================
# Homebrew (dynamic detection)
if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_PREFIX="$(brew --prefix)"
fi

# ===========================
# OPTIMIZED COMPLETION (portable cache)
# ===========================
autoload -Uz compinit
local _zcdump="${ZDOTDIR:-$HOME}/.zcompdump"

# Rebuild dump if missing or older than 24 hours; otherwise trust cache
if [[ ! -f ${_zcdump} || ${_zcdump}(#qN.mh+24) ]]; then
  compinit
  [[ -f ${_zcdump} ]] && zcompile -Uz -- ${_zcdump} 2>/dev/null || true
else
  compinit -C
fi

# Minimal completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# ===========================
# OTHER TOOLS (DEFERRED)
# ===========================

# Zoxide (if installed)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# FZF (if installed)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ===========================
# ZSH OPTIONS & HISTORY
# ===========================
# History settings (used as fallback if atuin not available)
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Set ZSH options
setopt AUTO_CD INTERACTIVE_COMMENTS
setopt HIST_IGNORE_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY EXTENDED_HISTORY
setopt INC_APPEND_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_VERIFY

# ===========================
# ATUIN - Advanced Shell History
# ===========================
# Initialize atuin if installed (replaces default history search)
if command -v atuin &>/dev/null; then
  # Disable default history search bindings
  bindkey -r '^R'
  
  # Initialize atuin with minimal overhead
  eval "$(atuin init zsh --disable-up-arrow)"
  
  # Custom keybindings for better integration
  bindkey '^R' _atuin_search_widget  # Keep Ctrl+R for atuin search
fi

# ===========================
# ALIASES
# ===========================


# Source user aliases if exists
[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

# Source user functions if exists
[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"

# ===========================
# TOOL INTEGRATIONS
# ===========================
# Direnv - automatic environment loading (only if installed)
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# (duplicate avoided) zoxide already initialized above if available

. "$HOME/.local/bin/env"

# Created by `pipx` on 2025-11-01 03:35:06
export PATH="$PATH:/Users/ab/Library/Python/3.9/bin"
