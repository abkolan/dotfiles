#!/usr/bin/env bash
# 🚀 One-Click Dotfiles Setup
# Clone the repo, run this script, and everything just works!

set -e

# ===========================
# Colors for output
# ===========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ===========================
# Helper Functions
# ===========================
print_step() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# ===========================
# Platform Detection
# ===========================
detect_platform() {
    case "$OSTYPE" in
        darwin*)  PLATFORM="macos" ;;
        linux*)   PLATFORM="linux" ;;
        *)        echo "Unsupported platform: $OSTYPE"; exit 1 ;;
    esac
    print_info "Detected platform: $PLATFORM"
}

# ===========================
# Package Manager Setup
# ===========================
setup_package_manager() {
    print_step "📦 Setting up package manager"
    
    if [[ "$PLATFORM" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            print_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for current session
            if [[ -f /opt/homebrew/bin/brew ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f /usr/local/bin/brew ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        print_success "Homebrew ready"
    else
        # Linux - update package manager
        if command -v apt-get &> /dev/null; then
            print_info "Updating apt packages..."
            sudo apt-get update -qq
        elif command -v yum &> /dev/null; then
            print_info "Updating yum packages..."
            sudo yum update -y -q
        elif command -v pacman &> /dev/null; then
            print_info "Updating pacman packages..."
            sudo pacman -Sy --noconfirm --quiet
        fi
        print_success "Package manager ready"
    fi
}

# ===========================
# Install Core Dependencies
# ===========================
install_core_deps() {
    print_step "🔧 Installing core dependencies"
    
    local deps=(git curl wget stow zsh neovim)
    
    if [[ "$PLATFORM" == "macos" ]]; then
        # Install from Brewfile if it exists
        if [[ -f "Brewfile" ]]; then
            print_info "Installing from Brewfile..."
            brew bundle --quiet
        else
            # Install core deps
            for dep in "${deps[@]}"; do
                if ! command -v "$dep" &> /dev/null; then
                    print_info "Installing $dep..."
                    brew install "$dep" --quiet
                fi
            done
        fi
    else
        # Linux package installation
        local missing_deps=()
        for dep in "${deps[@]}"; do
            if ! command -v "$dep" &> /dev/null; then
                missing_deps+=("$dep")
            fi
        done
        
        if [[ ${#missing_deps[@]} -gt 0 ]]; then
            if command -v apt-get &> /dev/null; then
                print_info "Installing: ${missing_deps[*]}"
                sudo apt-get install -y -qq "${missing_deps[@]}"
            elif command -v yum &> /dev/null; then
                sudo yum install -y -q "${missing_deps[@]}"
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm --quiet "${missing_deps[@]}"
            fi
        fi
    fi
    
    print_success "Core dependencies installed"
}

# ===========================
# Install Dev Tools
# ===========================
install_dev_tools() {
    print_step "🛠️ Installing development tools"
    
    # FZF
    if ! command -v fzf &> /dev/null; then
        print_info "Installing FZF..."
        if [[ "$PLATFORM" == "macos" ]]; then
            brew install fzf --quiet
        else
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null || true
            ~/.fzf/install --all --no-bash --no-fish >/dev/null 2>&1 || true
        fi
    fi
    
    # Ripgrep
    if ! command -v rg &> /dev/null; then
        print_info "Installing ripgrep..."
        if [[ "$PLATFORM" == "macos" ]]; then
            brew install ripgrep --quiet
        else
            if command -v apt-get &> /dev/null; then
                sudo apt-get install -y -qq ripgrep
            fi
        fi
    fi
    
    # fd
    if ! command -v fd &> /dev/null; then
        print_info "Installing fd..."
        if [[ "$PLATFORM" == "macos" ]]; then
            brew install fd --quiet
        else
            if command -v apt-get &> /dev/null; then
                sudo apt-get install -y -qq fd-find
                # Create symlink for fd
                sudo ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true
            fi
        fi
    fi
    
    # bat
    if ! command -v bat &> /dev/null; then
        print_info "Installing bat..."
        if [[ "$PLATFORM" == "macos" ]]; then
            brew install bat --quiet
        else
            if command -v apt-get &> /dev/null; then
                sudo apt-get install -y -qq bat
            fi
        fi
    fi
    
    # eza (modern ls)
    if ! command -v eza &> /dev/null; then
        print_info "Installing eza..."
        if [[ "$PLATFORM" == "macos" ]]; then
            brew install eza --quiet
        else
            # Install from GitHub releases for Linux
            curl -sL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | \
                tar xz -C ~/.local/bin 2>/dev/null || true
        fi
    fi
    
    print_success "Development tools installed"
}

# ===========================
# Setup Dotfiles
# ===========================
setup_dotfiles() {
    print_step "🔗 Setting up dotfiles with GNU Stow"
    
    # Ensure we're in the dotfiles directory
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$DOTFILES_DIR"
    
    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    
    # Stow configurations
    local configs=(git zsh nvim)
    if [[ "$PLATFORM" == "macos" ]]; then
        configs+=(kitty ghostty)
    fi
    
    # Add any other directories that exist
    for dir in */; do
        dir=${dir%/}
        if [[ ! " ${configs[@]} " =~ " ${dir} " ]] && \
           [[ "$dir" != "tests" ]] && \
           [[ "$dir" != "scripts" ]] && \
           [[ "$dir" != ".git" ]]; then
            configs+=("$dir")
        fi
    done
    
    for config in "${configs[@]}"; do
        if [[ -d "$config" ]]; then
            print_info "Stowing $config..."
            stow -R "$config" 2>/dev/null || {
                print_error "Failed to stow $config (may already exist)"
            }
        fi
    done
    
    print_success "Dotfiles linked"
}

# ===========================
# Setup ZSH
# ===========================
setup_zsh() {
    print_step "🐚 Setting up ZSH"
    
    # Install Zinit
    if [[ ! -d "$HOME/.local/share/zinit/zinit.git" ]]; then
        print_info "Installing Zinit plugin manager..."
        mkdir -p "$HOME/.local/share/zinit"
        git clone https://github.com/zdharma-continuum/zinit.git \
            "$HOME/.local/share/zinit/zinit.git" --quiet
    fi
    
    # Make ZSH the default shell (if not already)
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_info "Setting ZSH as default shell..."
        if [[ "$PLATFORM" == "macos" ]]; then
            chsh -s /bin/zsh
        else
            sudo chsh -s $(which zsh) $USER
        fi
    fi
    
    # Initialize ZSH plugins (non-interactively)
    print_info "Initializing ZSH plugins (this may take a moment)..."
    # Suppress Zinit's fancy output
    export ZINIT_NO_ALIASES=1
    export NO_AT_ALIASES=1
    zsh -i -c "exit" &>/dev/null || true
    
    print_success "ZSH configured"
}

# ===========================
# Setup Neovim
# ===========================
setup_neovim() {
    print_step "📝 Setting up Neovim"
    
    if command -v nvim &> /dev/null; then
        print_info "Installing Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
        print_success "Neovim configured"
    else
        print_error "Neovim not found, skipping plugin installation"
    fi
}

# ===========================
# Fix Paths
# ===========================
fix_paths() {
    print_step "🔧 Fixing hardcoded paths"
    
    # Fix any hardcoded /Users/ab paths
    if [[ "$HOME" != "/Users/ab" ]]; then
        find . -type f \( -name "*.zsh" -o -name ".zshrc" -o -name "*.sh" \) \
            -exec grep -l "/Users/ab" {} \; 2>/dev/null | while read -r file; do
            print_info "Fixing paths in $file"
            sed -i.bak "s|/Users/ab|$HOME|g" "$file"
            rm "${file}.bak" 2>/dev/null || true
        done
    fi
    
    print_success "Paths fixed"
}

# ===========================
# Post Setup
# ===========================
post_setup() {
    print_step "✨ Finalizing setup"
    
    # Create a quick test to verify everything works
    print_info "Verifying installation..."
    
    local checks_passed=0
    local checks_total=0
    
    # Check ZSH
    ((checks_total++))
    if [[ -f "$HOME/.zshrc" ]]; then
        print_success "ZSH configuration found"
        ((checks_passed++))
    else
        print_error "ZSH configuration missing"
    fi
    
    # Check Neovim
    ((checks_total++))
    if [[ -d "$HOME/.config/nvim" ]]; then
        print_success "Neovim configuration found"
        ((checks_passed++))
    else
        print_error "Neovim configuration missing"
    fi
    
    # Check Git
    ((checks_total++))
    if [[ -f "$HOME/.gitconfig" ]]; then
        print_success "Git configuration found"
        ((checks_passed++))
    else
        print_error "Git configuration missing"
    fi
    
    # Check Zinit
    ((checks_total++))
    if [[ -d "$HOME/.local/share/zinit/zinit.git" ]]; then
        print_success "Zinit plugin manager installed"
        ((checks_passed++))
    else
        print_error "Zinit not installed"
    fi
    
    echo ""
    print_info "Checks passed: $checks_passed/$checks_total"
}

# ===========================
# Main Installation
# ===========================
main() {
    clear
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           🚀 DOTFILES ONE-CLICK SETUP SCRIPT 🚀             ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Run all setup steps
    detect_platform
    setup_package_manager
    install_core_deps
    install_dev_tools
    fix_paths
    setup_dotfiles
    setup_zsh
    setup_neovim
    post_setup
    
    # Success message
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    ✅ SETUP COMPLETE! ✅                      ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  1. ${YELLOW}Restart your terminal${NC} or run: ${GREEN}exec zsh${NC}"
    echo -e "  2. ${YELLOW}Open Neovim${NC} and plugins will auto-install"
    if [[ "$PLATFORM" == "macos" ]]; then
        echo -e "  3. ${YELLOW}Restart Kitty/Ghostty${NC} if you use them"
    fi
    echo ""
    echo -e "${CYAN}Test your setup:${NC}"
    echo -e "  ${GREEN}./tests/run-tests.sh${NC} - Run the test suite"
    echo ""
    echo -e "${BLUE}Enjoy your new development environment! 🎉${NC}"
    echo ""
}

# Run the setup
main "$@"