#!/bin/bash
# macOS-focused installation script for testing

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🚀 Starting macOS dotfiles installation for tests..."

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This helper only supports macOS${NC}"
    exit 1
fi

echo "📍 Detected platform: macOS"

# ===========================
# Package Manager Setup
# ===========================
install_package_manager() {
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [[ -d "/opt/homebrew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -d "/usr/local" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "✅ Homebrew already installed"
    fi
}

# ===========================
# Install Core Dependencies
# ===========================
install_core_deps() {
    echo "📦 Installing core dependencies..."
    brew install git stow curl wget || true
}

# ===========================
# Install Development Tools
# ===========================
install_dev_tools() {
    echo "📦 Installing development tools..."

    if [[ -f "Brewfile" ]]; then
        echo "  Using Brewfile..."
        brew bundle || true
    else
        local tools=(zsh neovim fd ripgrep fzf bat eza zoxide jq)
        for tool in "${tools[@]}"; do
            brew install "$tool" || true
        done
    fi
}

# ===========================
# Fix Hardcoded Paths
# ===========================
fix_paths() {
    echo "🔧 Fixing hardcoded paths..."

    if [[ -f "zsh/.zshrc" ]]; then
        sed -i.backup "s|/Users/ab|\$HOME|g" zsh/.zshrc 2>/dev/null || \
        sed -i'.backup' "s|/Users/ab|\$HOME|g" zsh/.zshrc
    fi

    if [[ -f "zsh/.zshrc.zinit" ]]; then
        sed -i.backup "s|/Users/ab|\$HOME|g" zsh/.zshrc.zinit 2>/dev/null || \
        sed -i'.backup' "s|/Users/ab|\$HOME|g" zsh/.zshrc.zinit
    fi
}

# ===========================
# Create Directories
# ===========================
create_directories() {
    echo "📁 Creating necessary directories..."
    mkdir -p ~/.config
    mkdir -p ~/.local/share
    mkdir -p ~/.cache
}

# ===========================
# Stow Configurations
# ===========================
stow_configs() {
    echo "🔗 Setting up symlinks with stow..."

    local configs=(git zsh nvim kitty ghostty ripgrep lsd btop broot go linearmouse)

    for config in "${configs[@]}"; do
        if [[ -d "$config" ]]; then
            echo "  → Stowing $config..."
            stow -R "$config" 2>/dev/null || {
                echo -e "${YELLOW}  Warning: Failed to stow $config${NC}"
            }
        fi
    done
}

# ===========================
# Post-Install Setup
# ===========================
post_install() {
    echo "🔧 Running post-install setup..."

    if command -v nvim &> /dev/null; then
        echo "  Installing Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    fi

    if [[ ! -d "$HOME/.local/share/zinit/zinit.git" ]]; then
        echo "  Installing Zinit..."
        mkdir -p "$HOME/.local/share/zinit"
        git clone https://github.com/zdharma-continuum/zinit.git \
            "$HOME/.local/share/zinit/zinit.git" 2>/dev/null || true
    fi

    if command -v zsh &> /dev/null && [[ -f "$HOME/.zshrc" ]]; then
        echo "  Initializing ZSH plugins..."
        export ZINIT_NO_ALIASES=1
        export NO_AT_ALIASES=1
        zsh -i -c "zinit self-update" &>/dev/null || true
        zsh -i -c "zinit update --all" &>/dev/null || true
        zsh -i -c "autoload -Uz compinit && compinit" &>/dev/null || true
    fi
}

# ===========================
# Main Installation Flow
# ===========================
main() {
    if [[ ! -f "install.sh" ]] && [[ ! -f "tests/install-platform-agnostic.sh" ]]; then
        echo -e "${RED}Error: Not in dotfiles directory${NC}"
        exit 1
    fi

    install_package_manager
    install_core_deps
    install_dev_tools
    fix_paths
    create_directories
    stow_configs
    post_install

    echo ""
    echo "✅ Installation complete!"
    echo ""
    echo "📝 Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Open Neovim and wait for plugins to install"
    echo "  3. Open Kitty and reload config: Cmd+Ctrl+F5"
    echo ""
    echo "Run tests with: ./tests/run-tests.sh"
}

main "$@"
