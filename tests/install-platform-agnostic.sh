#!/bin/bash
# Platform-agnostic installation script for testing
# This replaces the macOS-only install.sh for testing purposes

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🚀 Starting platform-agnostic dotfiles installation..."

# ===========================
# Platform Detection
# ===========================
detect_platform() {
    case "$OSTYPE" in
        darwin*)  echo "macos" ;;
        linux*)   echo "linux" ;;
        *)        echo "unknown" ;;
    esac
}

PLATFORM=$(detect_platform)
echo "📍 Detected platform: $PLATFORM"

# ===========================
# Package Manager Setup
# ===========================
install_package_manager() {
    if [[ "$PLATFORM" == "macos" ]]; then
        # Install Homebrew on macOS
        if ! command -v brew &> /dev/null; then
            echo "📦 Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH
            if [[ -d "/opt/homebrew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -d "/usr/local" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        else
            echo "✅ Homebrew already installed"
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        # Update package manager on Linux
        echo "📦 Updating package manager..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update || true
        elif command -v yum &> /dev/null; then
            sudo yum update -y || true
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy || true
        fi
    fi
}

# ===========================
# Install Core Dependencies
# ===========================
install_core_deps() {
    echo "📦 Installing core dependencies..."
    
    if [[ "$PLATFORM" == "macos" ]]; then
        # macOS dependencies via Homebrew
        brew install git stow curl wget || true
    elif [[ "$PLATFORM" == "linux" ]]; then
        # Linux dependencies
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y git stow curl wget build-essential || true
        elif command -v yum &> /dev/null; then
            sudo yum install -y git stow curl wget gcc make || true
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm git stow curl wget base-devel || true
        fi
    fi
}

# ===========================
# Install Development Tools
# ===========================
install_dev_tools() {
    echo "📦 Installing development tools..."
    
    local tools=(
        "zsh"
        "neovim"
        "fd"
        "ripgrep"
        "fzf"
        "bat"
        "eza"
        "zoxide"
        "jq"
    )
    
    if [[ "$PLATFORM" == "macos" ]]; then
        # Install from Brewfile if it exists
        if [[ -f "Brewfile" ]]; then
            echo "  Using Brewfile for macOS..."
            # Filter out Linux-incompatible casks for CI environments
            if [[ "${CI:-false}" == "true" ]]; then
                grep -v "^cask " Brewfile > Brewfile.ci
                brew bundle --file=Brewfile.ci || true
                rm Brewfile.ci
            else
                brew bundle || true
            fi
        else
            # Fallback to individual installs
            for tool in "${tools[@]}"; do
                brew install "$tool" || true
            done
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        # Linux installation
        if command -v apt-get &> /dev/null; then
            # Ubuntu/Debian
            sudo apt-get install -y zsh neovim ripgrep fzf bat jq || true
            
            # fd has different package names
            sudo apt-get install -y fd-find || sudo apt-get install -y fd || true
            
            # Create fd symlink if needed
            if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
                sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
            fi
            
            # eza might not be in default repos
            if ! command -v eza &> /dev/null; then
                echo "  Installing eza from GitHub..."
                curl -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
                sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin
                rm /tmp/eza.tar.gz
            fi
            
            # zoxide installation
            if ! command -v zoxide &> /dev/null; then
                echo "  Installing zoxide..."
                curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash || true
            fi
        elif command -v yum &> /dev/null; then
            # RHEL/CentOS/Fedora
            sudo yum install -y zsh neovim ripgrep fzf bat jq || true
            # Note: Some tools might need EPEL or other repos
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            sudo pacman -S --noconfirm zsh neovim ripgrep fzf bat eza zoxide fd jq || true
        fi
    fi
}

# ===========================
# Fix Hardcoded Paths
# ===========================
fix_paths() {
    echo "🔧 Fixing hardcoded paths..."
    
    # Fix any hardcoded /Users/ab paths
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
    
    # Platform-specific stow list
    if [[ "$PLATFORM" == "macos" ]]; then
        configs=(git zsh nvim kitty ghostty ripgrep lsd btop broot go linearmouse)
    else
        # Skip macOS-only configs on Linux
        configs=(git zsh nvim ripgrep lsd btop broot go)
    fi
    
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
    
    # Install Neovim plugins (if nvim is available)
    if command -v nvim &> /dev/null; then
        echo "  Installing Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    fi
    
    # Install Zinit for ZSH
    if [[ ! -d "$HOME/.local/share/zinit/zinit.git" ]]; then
        echo "  Installing Zinit..."
        mkdir -p "$HOME/.local/share/zinit"
        git clone https://github.com/zdharma-continuum/zinit.git \
            "$HOME/.local/share/zinit/zinit.git" 2>/dev/null || true
    fi
    
    # Initialize ZSH plugins (force load on first run)
    if command -v zsh &> /dev/null && [[ -f "$HOME/.zshrc" ]]; then
        echo "  Initializing ZSH plugins..."
        # Set environment to suppress Zinit's fancy output in non-interactive mode
        export ZINIT_NO_ALIASES=1
        export NO_AT_ALIASES=1
        # Run zsh to trigger plugin installation (redirect output to avoid formatting issues)
        zsh -i -c "zinit self-update" &>/dev/null || true
        zsh -i -c "zinit update --all" &>/dev/null || true
        # Create completion dump
        zsh -i -c "autoload -Uz compinit && compinit" &>/dev/null || true
    fi
}

# ===========================
# Main Installation Flow
# ===========================
main() {
    # Ensure we're in the dotfiles directory
    if [[ ! -f "install.sh" ]] && [[ ! -f "tests/install-platform-agnostic.sh" ]]; then
        echo -e "${RED}Error: Not in dotfiles directory${NC}"
        exit 1
    fi
    
    # Run installation steps
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
    
    if [[ "$PLATFORM" == "macos" ]]; then
        echo "  3. Open Kitty and reload config: Cmd+Ctrl+F5"
    fi
    
    echo ""
    echo "Run tests with: ./tests/run-tests.sh"
}

# Run main installation
main "$@"