#!/bin/bash

# Ultimate DevOps Neovim Setup Script
# Run this script on any new system to set up the complete configuration

set -e

echo "🚀 Setting up Ultimate DevOps Neovim Configuration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# macOS only
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo -e "${BLUE}🔍 Detected OS: macOS${NC}"

# Install dependencies
install_dependencies() {
    echo -e "${BLUE}📦 Installing dependencies...${NC}"
    
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}🍺 Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo -e "${BLUE}📦 Installing packages via Homebrew...${NC}"
    brew install neovim fd ripgrep fzf git curl wget

    # Optional DevOps tools
    if command -v kubectl &> /dev/null; then
        echo -e "${GREEN}✅ kubectl already installed${NC}"
    else
        echo -e "${YELLOW}⚠️  kubectl not found. Install manually if needed for Kubernetes workflows${NC}"
    fi
}

# Install Node.js for LSP servers
install_nodejs() {
    if ! command -v node &> /dev/null; then
        echo -e "${BLUE}📦 Installing Node.js...${NC}"
        brew install node
    else
        echo -e "${GREEN}✅ Node.js already installed${NC}"
    fi
}

# Setup Neovim configuration
setup_neovim_config() {
    echo -e "${BLUE}⚙️  Setting up Neovim configuration...${NC}"
    
    # Backup existing config if it exists
    if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        echo -e "${YELLOW}📦 Backing up existing Neovim config...${NC}"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Create config directory
    mkdir -p "$HOME/.config"
    
    # If this script is run from the nvim config directory, copy it
    if [ -f "$(dirname "$0")/init.lua" ]; then
        echo -e "${BLUE}📁 Copying configuration files...${NC}"
        cp -r "$(dirname "$0")" "$HOME/.config/nvim"
    else
        echo -e "${RED}❌ Configuration files not found. Make sure to run this script from the nvim config directory.${NC}"
        exit 1
    fi
}

# Install language servers and tools
install_language_servers() {
    echo -e "${BLUE}🛠️  Installing additional language servers...${NC}"
    
    # Python tools
    if command -v pip3 &> /dev/null; then
        echo -e "${BLUE}🐍 Installing Python tools...${NC}"
        pip3 install --user pynvim black yamllint
    fi
    
    # Go tools (if Go is installed)
    if command -v go &> /dev/null; then
        echo -e "${BLUE}🐹 Installing Go tools...${NC}"
        go install golang.org/x/tools/gopls@latest
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    fi
    
    # Terraform (if needed)
    if ! command -v terraform &> /dev/null; then
        echo -e "${YELLOW}⚠️  Terraform not found. Install manually if needed for IaC workflows${NC}"
    fi
}

# Main installation
main() {
    echo -e "${GREEN}🚀 Starting Ultimate DevOps Neovim Setup${NC}"
    echo ""
    
    install_dependencies
    install_nodejs
    setup_neovim_config
    install_language_servers
    
    echo ""
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo -e "${BLUE}🎯 Next steps:${NC}"
    echo "1. Run: nvim"
    echo "2. Wait for plugins to install automatically"
    echo "3. LSP servers will install automatically on first startup"
    echo "4. Use <C-p> to start file navigation"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo "- README.md in ~/.config/nvim/ for all shortcuts"
    echo "- Use :checkhealth to verify installation"
    echo ""
    echo -e "${GREEN}🎉 Happy coding with your supercharged Neovim!${NC}"
}

# Run main function
main "$@"
