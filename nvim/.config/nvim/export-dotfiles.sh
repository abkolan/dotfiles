#!/bin/bash

# Export Neovim Configuration to Dotfiles
# Creates a portable package of your Neovim setup

set -e

echo "📦 Exporting Ultimate DevOps Neovim Configuration..."

# Configuration
EXPORT_DIR="$HOME/nvim-dotfiles-$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$HOME/.config/nvim"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Create export directory
mkdir -p "$EXPORT_DIR"

echo -e "${BLUE}📁 Creating export package in: $EXPORT_DIR${NC}"

# Copy entire nvim configuration
echo -e "${BLUE}📋 Copying Neovim configuration...${NC}"
cp -r "$CONFIG_DIR"/* "$EXPORT_DIR/"

# Create a .gitignore for the export
cat > "$EXPORT_DIR/.gitignore" << 'EOF'
# Neovim
lazy-lock.json
.DS_Store
*.log

# Mason installations (will be reinstalled automatically)
# Lazy plugin cache (will be rebuilt)

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF

# Create setup instructions
cat > "$EXPORT_DIR/SETUP.md" << 'EOF'
# 🚀 Ultimate DevOps Neovim Setup

## Quick Setup on New System

### Automatic Setup (Recommended)
```bash
# 1. Clone or copy this directory to new system
# 2. Run the automated installer
chmod +x install.sh
./install.sh
```

### Manual Setup
```bash
# 1. Install dependencies
# macOS: brew install neovim fd ripgrep fzf git curl wget node

# 2. Copy config to ~/.config/nvim/
cp -r . ~/.config/nvim/

# 3. Start Neovim (plugins will auto-install)
nvim
```

## Features Included

✅ **Lightning-fast file navigation** (`<C-p>`, `<C-f>`)  
✅ **Multi-file management** (splits, tabs, buffers)  
✅ **Kubernetes LSP support** (auto-schema validation)  
✅ **DevOps workflows** (Terraform, Docker, Go, Python)  
✅ **Git integration** with diff views  
✅ **Harpoon** for instant file switching  
✅ **Auto-installing LSP servers** (yamlls, gopls, pyright, etc.)  

## First Time Usage

1. Start Neovim: `nvim`
2. Wait for plugins to install (will happen automatically)
3. LSP servers install automatically on first use
4. Use `<C-p>` to start file navigation
5. Read `README.md` for all shortcuts and workflows

## Verification

Run health check: `:checkhealth`  
View installed LSP servers: `:Mason`

🎉 **Happy coding!**
EOF

# Create a simple GitHub Actions workflow if requested
read -p "📋 Create GitHub Actions workflow for automated testing? (y/n): " create_workflow
if [[ $create_workflow =~ ^[Yy]$ ]]; then
    mkdir -p "$EXPORT_DIR/.github/workflows"
    cat > "$EXPORT_DIR/.github/workflows/test.yml" << 'EOF'
name: Test Neovim Configuration

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y neovim fd-find ripgrep fzf git curl wget nodejs npm
        sudo ln -s $(which fdfind) /usr/local/bin/fd
    
    - name: Set up Neovim config
      run: |
        mkdir -p ~/.config
        cp -r . ~/.config/nvim
    
    - name: Test Neovim startup
      run: |
        nvim --headless -c "sleep 10" -c "qa"
    
    - name: Check health
      run: |
        nvim --headless -c "checkhealth" -c "qa" > /dev/null 2>&1 || true
EOF
    echo -e "${GREEN}✅ GitHub Actions workflow created${NC}"
fi

# Create archive
echo -e "${BLUE}📦 Creating archive...${NC}"
cd "$(dirname "$EXPORT_DIR")"
tar -czf "$(basename "$EXPORT_DIR").tar.gz" "$(basename "$EXPORT_DIR")"

echo ""
echo -e "${GREEN}✅ Export complete!${NC}"
echo ""
echo -e "${BLUE}📁 Export location:${NC} $EXPORT_DIR"
echo -e "${BLUE}📦 Archive created:${NC} $EXPORT_DIR.tar.gz"
echo ""
echo -e "${YELLOW}🚀 To use on new system:${NC}"
echo "1. Copy the directory or extract the archive"
echo "2. Run: chmod +x install.sh && ./install.sh"
echo "3. Start Neovim and enjoy!"
echo ""
echo -e "${BLUE}💡 Tip:${NC} Add this to your dotfiles repository for version control"
