# 🚀 My Dotfiles

My personal dotfiles setup optimized for DevOps workflows, managed with GNU Stow.

## 📦 What's Included

### 🔧 Neovim Configuration
- **Lightning-fast navigation** with FZF and Telescope
- **Kubernetes LSP support** with auto-schema validation  
- **Multi-file management** (splits, tabs, buffers)
- **DevOps workflows** (Terraform, Docker, Go, Python, Helm)
- **Auto-installing LSP servers** for zero-config setup
- **Git integration** with diff views
- **Harpoon** for instant file switching

### 🐚 Shell & Terminal (if added)
- [**zsh**](https://www.zsh.org/) - Extended shell with improvements
- Custom aliases and functions for DevOps workflows

### 🛠️ Development Tools
- [**git**](https://git-scm.com/) - Version control configuration
- Modern CLI tools (fd, ripgrep, fzf)

## Installation

### 🚀 Quick Start (Recommended)

Clone and run the setup script - it handles everything automatically:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

That's it! The script will:
- ✅ Install all dependencies (Homebrew, packages, tools)
- ✅ Set up ZSH with Zinit and plugins
- ✅ Configure Neovim with plugins
- ✅ Link all dotfiles with GNU Stow
- ✅ Fix any hardcoded paths
- ✅ Verify everything works

### Manual Installation

If you prefer to install manually:

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   ```

2. Install GNU Stow:
   ```bash
   # macOS
   brew install stow
   
   # Debian/Ubuntu
   sudo apt-get install stow
   ```

3. Use Stow to create symlinks:
   ```bash
   cd ~/dotfiles
   stow zsh nvim git
   ```

## 🧪 Testing

This repository includes a comprehensive, platform-agnostic test suite to ensure your dotfiles work correctly across different environments.

### Quick Start

Run all tests:
```bash
./tests/run-tests.sh
```

### Testing Individual Components

Test specific configurations independently:

```bash
# Test ZSH configuration
./tests/run-tests.sh zsh

# Test Neovim configuration  
./tests/run-tests.sh nvim

# Test Kitty terminal (macOS only)
./tests/run-tests.sh kitty

# Test Git configuration
./tests/run-tests.sh git
```

### Testing Options

```bash
# Run with verbose output for debugging
./tests/run-tests.sh --verbose

# Test in Docker container (Linux environment)
./tests/run-tests.sh --docker

# Test fresh installation first, then run tests
./tests/run-tests.sh --install

# FAST Docker testing (after first run)
./tests/test-fast.sh        # ~20 seconds vs 2-3 minutes
```

### 🚀 Fast Integration Testing

For rapid iteration, use the fast test script:

```bash
# First time setup (builds base image, ~2-3 minutes)
./tests/test-fast.sh

# Subsequent runs (~20 seconds)
./tests/test-fast.sh zsh    # Test specific component
./tests/test-fast.sh all    # Test everything
```

The fast test uses a pre-built Docker base image with all dependencies cached.

### What Gets Tested

- **ZSH**: Startup performance (<150ms macOS, <500ms Linux/Docker), plugin loading, aliases, completions
- **Neovim**: Configuration syntax, plugin loading, LSP setup, performance
- **Kitty**: Terminal configuration, themes, fonts, key mappings (macOS)
- **Git**: User config, aliases, tools integration, hooks
- **Integration**: Cross-component functionality, aliases, performance

### CI/CD Testing

Tests run automatically on every pull request via GitHub Actions on:
- macOS (latest)
- Ubuntu (latest)
- Docker container (isolated Linux environment)

The test suite validates that `git clone → install → everything works` on fresh systems.

For more details, see [tests/README.md](tests/README.md).

## 📚 Component Documentation

Each component in this dotfiles setup has its own detailed documentation:

### Core Components
- [**Neovim**](nvim/README.md) - Text editor configuration with LSP, plugins, and DevOps tools
- [**ZSH**](zsh/README.md) - Shell configuration with aliases, functions, and performance optimizations
- [**Git**](git/README.md) - Version control configuration, aliases, and workflow tools
- [**Kitty**](kitty/README.md) - Terminal emulator configuration and themes

### Development Tools
- [**Go**](go/README.md) - Go development environment setup
- [**Broot**](broot/README.md) - Modern tree view and file navigation
- [**Ripgrep**](ripgrep/README.md) - Fast text search configuration
- [**LSD**](lsd/README.md) - Modern `ls` replacement configuration

### System Tools
- [**Btop**](btop/README.md) - System monitor configuration
- [**Ghostty**](ghostty/README.md) - GPU-accelerated terminal configuration
- [**Linear Mouse**](linearmouse/README.md) - Mouse acceleration configuration

### Utilities
- [**Scripts**](scripts/README.md) - Automation scripts and utilities
- [**Scratchpad**](scratchpad/README.md) - Quick notes and temporary files

### Testing & CI
- [**Tests**](tests/README.md) - Comprehensive testing framework
- [**GitHub Actions**](tests/github-actions/README.md) - CI/CD pipeline configuration

## Sync Between Machines

This repository includes a script to synchronize dotfiles between machines:

```bash
#!/bin/bash
# sync.sh - Simple dotfiles sync

# Pull latest changes
cd ~/dotfiles && git pull

# Install/update packages
brew bundle

# Stow all configs (except .git and scripts)
for dir in */; do
  dir=${dir%/}
  if [[ "$dir" != ".git" && "$dir" != "scripts" ]]; then
    stow -R "$dir"
  fi
done

echo "✅ Sync complete!"
```

### Usage:

**On primary machine (when adding new tools):**
```bash
brew install new-tool
cd ~/dotfiles
brew bundle dump --force
git add .
git commit -m "Add new-tool"
git push
```

**On secondary machine (to sync):**
```bash
~/dotfiles/sync.sh
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
