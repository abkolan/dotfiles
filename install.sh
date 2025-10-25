#!/bin/bash

# 🚀 Dotfiles Installation Script for New Systems
# This script sets up a fresh macOS system with all dotfiles

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Starting dotfiles installation..."

# 1. Check OS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}This script supports macOS only.${NC}"
    exit 1
fi

# 2. Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -d "/opt/homebrew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# 3. Install GNU Stow
if ! command -v stow &> /dev/null; then
    echo "📦 Installing GNU Stow..."
    brew install stow
else
    echo "✅ Stow already installed"
fi

# 4. Clone dotfiles if not in ~/dotfiles
if [ ! -d "$HOME/dotfiles" ]; then
    echo "📦 Cloning dotfiles repository..."
    echo -e "${YELLOW}Enter your dotfiles repo URL (or press Enter for local copy):${NC}"
    read -r REPO_URL
    if [ -n "$REPO_URL" ]; then
        git clone "$REPO_URL" ~/dotfiles
    else
        echo "Assuming dotfiles are already in ~/dotfiles"
    fi
fi

cd ~/dotfiles

# 5. Install Brewfile packages
if [ -f "Brewfile" ]; then
    echo "📦 Installing packages from Brewfile..."
    brew bundle
else
    echo -e "${YELLOW}No Brewfile found, skipping brew bundle${NC}"
fi

# 6. Fix hardcoded paths in zsh configs
echo "🔧 Fixing user-specific paths..."
if [ -f "zsh/.zshrc" ]; then
    # Replace hardcoded conda paths with $HOME
    sed -i.backup "s|/Users/ab|$HOME|g" zsh/.zshrc
    sed -i.backup "s|/Users/ab|$HOME|g" zsh/.zshrc.zinit 2>/dev/null || true
    echo "✅ Fixed paths in zsh configs"
fi

# 7. Create necessary directories
echo "📁 Creating config directories..."
mkdir -p ~/.config
mkdir -p ~/.local/share
mkdir -p ~/.cache

# 8. Stow configurations in order
echo "🔗 Setting up symlinks with stow..."

# Order matters for some configs
STOW_ORDER=(
    "git"       # Git should be first
    "zsh"       # Shell config
    "nvim"      # Neovim
    "kitty"     # Terminal
    "ghostty"   # GPU terminal
    "ripgrep"   # Search tool
    "lsd"       # ls replacement
    "btop"      # System monitor
    "broot"     # File manager
    "atuin"     # Shell history
    "go"        # Go config
    "linearmouse" # Mouse config
)

for config in "${STOW_ORDER[@]}"; do
    if [ -d "$config" ]; then
        echo "  → Stowing $config..."
        stow -R "$config" 2>/dev/null || {
            echo -e "${YELLOW}Warning: Failed to stow $config, continuing...${NC}"
        }
    fi
done

# 9. Install Neovim plugins
if command -v nvim &> /dev/null; then
    echo "📦 Installing Neovim plugins..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || {
        echo -e "${YELLOW}Note: Run 'nvim' and ':Lazy sync' to install plugins${NC}"
    }
fi

# 10. Source zsh config
if [ -f "$HOME/.zshrc" ]; then
    echo "🐚 Sourcing zsh configuration..."
    source "$HOME/.zshrc" 2>/dev/null || true
fi

# 11. Final checks
echo ""
echo "🎉 Installation complete!"
echo ""
echo "📝 Post-installation steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open Neovim and run: :Lazy sync"
echo "  3. Reload Kitty config: Cmd+Shift+R (in Kitty)"
echo "  4. Configure git user:"
echo "     git config --global user.name 'Your Name'"
echo "     git config --global user.email 'your.email@example.com'"
echo ""
echo "🔧 Optional:"
echo "  - Install miniconda manually if needed"
echo "  - Configure GitHub CLI: gh auth login"
echo "  - Set up SSH keys for GitHub"
