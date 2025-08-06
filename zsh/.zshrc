# ===========================
# PERFORMANCE: Ultra-fast ZSH configuration with Zinit
# Replaces Oh My Zsh with a minimal, blazing-fast setup
# ===========================

# Enable Powerlevel10k instant prompt (MUST be first)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Skip all initialization in non-interactive environments
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then

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
  # PERFORMANCE: Zinit optimizations
  # ===========================
  zstyle ':zinit:*' use-cache yes
  zstyle ':zinit:*' cache-dir ~/.cache/zinit
  
  # ===========================
  # THEME: Powerlevel10k (turbo mode)
  # ===========================
  zinit ice depth=1
  zinit light romkatv/powerlevel10k
  
  # ===========================
  # ESSENTIAL PLUGINS (loaded immediately)
  # ===========================
  
  # Git support (replaces oh-my-zsh git plugin)
  zinit ice wait lucid
  zinit snippet OMZP::git
  
  # Fast syntax highlighting (turbo mode)
  zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
  zinit light zdharma-continuum/fast-syntax-highlighting
  
  # Autosuggestions (turbo mode)
  zinit ice wait lucid atload"!_zsh_autosuggest_start"
  zinit load zsh-users/zsh-autosuggestions
  
  # ===========================
  # LAZY-LOADED PLUGINS
  # ===========================
  
  # History substring search (load on first up/down arrow)
  zinit ice wait"0b" lucid atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'
  zinit light zsh-users/zsh-history-substring-search
  
  # Additional completions (background load)
  zinit ice wait"0c" lucid blockf atpull'zinit creinstall -q .'
  zinit light zsh-users/zsh-completions
  
  # FZF tab completion (lazy load)
  zinit ice wait"1" lucid
  zinit light Aloxaf/fzf-tab
  
  # ===========================
  # PERFORMANCE: Lazy-load heavy functions
  # ===========================
  
  # Create autoload directory
  ZFUNCDIR="${ZDOTDIR:-$HOME}/.zsh_autoload"
  [[ -d "$ZFUNCDIR" ]] || mkdir -p "$ZFUNCDIR"
  fpath=("$ZFUNCDIR" $fpath)
  
  # Autoload all functions in the directory
  autoload -Uz $ZFUNCDIR/*(.:t)
  
  # ===========================
  # PERFORMANCE: Source configurations
  # ===========================
  
  # Source aliases (lightweight)
  [[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
  
  # Lazy-load functions on first use
  [[ -f "$HOME/.zsh_functions" ]] && {
    # Instead of sourcing, we'll create lazy wrappers
    source "$HOME/.zsh_functions_lazy"
  }
  
  # ===========================
  # PERFORMANCE: NVM lazy loading (unchanged)
  # ===========================
  export NVM_DIR="$HOME/.nvm"
  
  _load_nvm() {
    if ! command -v nvm >/dev/null 2>&1 || [[ $(type nvm) == *"function"* ]]; then
      [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
      [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    fi
  }
  
  nvm() {
    unfunction nvm 2>/dev/null
    _load_nvm
    nvm "$@"
  }
  
  node() {
    unfunction node 2>/dev/null
    _load_nvm
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
  # PERFORMANCE: Conda lazy loading (unchanged)
  # ===========================
  init_conda() {
    __conda_setup="$('/Users/ab/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    else
      if [ -f "/Users/ab/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ab/miniconda3/etc/profile.d/conda.sh"
      else
        export PATH="/Users/ab/miniconda3/bin:$PATH"
      fi
    fi
    unset __conda_setup
  }
  
  conda() {
    unfunction conda 2>/dev/null
    init_conda
    conda "$@"
  }
  
  # ===========================
  # PERFORMANCE: kubectl lazy loading (unchanged)
  # ===========================
  if command -v kubectl >/dev/null 2>&1; then
    kubectl() {
      unfunction kubectl
      source <(command kubectl completion zsh)
      command kubectl "$@"
    }
    alias k='kubectl'
  fi
  
  # ===========================
  # PERFORMANCE: Homebrew setup
  # ===========================
  if [[ -z "$HOMEBREW_PREFIX" ]]; then
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      export HOMEBREW_PREFIX="/opt/homebrew"
    elif [[ -x "/usr/local/bin/brew" ]]; then
      export HOMEBREW_PREFIX="/usr/local"
    else
      export HOMEBREW_PREFIX="/opt/homebrew"
    fi
  fi
  
  # ===========================
  # PERFORMANCE: Optimized completion
  # ===========================
  autoload -Uz compinit
  if [[ -f ${ZDOTDIR:-$HOME}/.zcompdump ]] && [[ ${ZDOTDIR:-$HOME}/.zcompdump -nt /usr/share/zsh ]] && [[ ! ${ZDOTDIR:-$HOME}/.zcompdump -ot ${ZDOTDIR:-$HOME}/.zshrc ]]; then
    compinit -C
  else
    compinit
  fi
  
  # Completion styling
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*' menu select
  
  # ===========================
  # OTHER TOOLS
  # ===========================
  
  # Zoxide (fast cd replacement)
  if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
  fi
  
  # FZF
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  
  # P10k config
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  
fi  # End of INTELLIJ_ENVIRONMENT_READER check

# ===========================
# PERFORMANCE: Set ZSH options
# ===========================
setopt AUTO_CD              # cd into directory by typing its name
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt HIST_IGNORE_DUPS     # Don't record duplicate commands
setopt HIST_REDUCE_BLANKS   # Remove extra blanks from commands
setopt SHARE_HISTORY        # Share history between sessions
setopt EXTENDED_HISTORY     # Record timestamp in history
setopt INC_APPEND_HISTORY   # Add commands immediately to history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY          # Show command with history expansion before running

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

