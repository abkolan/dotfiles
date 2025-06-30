# Powerlevel10k instant prompt (keep near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prevent config from running in IntelliJ shells
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then

  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="robbyrussell"

  CASE_SENSITIVE="true"
  ENABLE_CORRECTION="true"

  plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    you-should-use
  )

  source "$ZSH/oh-my-zsh.sh"

  # Editor
  export VISUAL=nvim
  export EDITOR="$VISUAL"

  # Source env/config
  [ -f "$HOME/.zshenv" ] && source "$HOME/.zshenv"
  [ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"
  [ -f "$HOME/.zsh_functions" ] && source "$HOME/.zsh_functions"

  # PATH setup
  export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  export PATH="$PATH:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin"
  export PATH="$PATH:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin"
  export PATH="$PATH:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"
  export PATH="$PATH:/Library/Apple/usr/bin"

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

  export PATH="$PATH:$(go env GOPATH)/bin"

  # Conda init (portable)
  if command -v conda >/dev/null 2>&1; then
    __conda_setup="$(conda 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
      . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
      export PATH="$HOME/anaconda3/bin:$PATH"
    fi
    unset __conda_setup
  fi

  export HOMEBREW_AUTO_UPDATE_SECS=86400
fi

# Docker CLI completions
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
compinit

# Powerlevel10k theme
[[ -f "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" ]] && \
  source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# z (jump around)
# [[ -f "$(brew --prefix)/etc/profile.d/z.sh" ]] && source "$(brew --prefix)/etc/profile.d/z.sh"
eval "$(zoxide init zsh)"

# Ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"

# broot launcher
[[ -f "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

# kubectl completions
# Enable kubectl completion in Zsh
autoload -Uz compinit
compinit

# Source kubectl completion
source <(kubectl completion zsh)

# Alias 'k' for kubectl
alias k=kubectl

# Enable completion for 'k' alias
compdef __start_kubectl k
