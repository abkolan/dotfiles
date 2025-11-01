# Dotfiles

Personal dotfiles setup optimized for DevOps workflows, managed with GNU Stow.

## 📦 What's Included

### Core Tools
- **Neovim** - Lightning-fast navigation with FZF and Telescope, LSP support, DevOps workflows
- **ZSH** - Extended shell with custom aliases, functions, and performance optimizations
- **Git** - Version control configuration with delta diffs and workflow aliases
- **Kitty** - Terminal emulator with theme system and keyboard shortcuts

### Development Tools
- **Go** - Development environment with linter configuration
- **Atuin** - Advanced shell history with fuzzy search and sync
- **Broot** - Interactive directory tree navigation
- **Ripgrep** - Fast text search with configuration
- **LSD** - Modern ls replacement

### System Tools
- **Btop** - Resource monitor with beautiful TUI
- **Ghostty** - GPU-accelerated terminal emulator
- **LinearMouse** - Mouse acceleration configuration

## 🚀 Installation

### Quick Start (macOS)

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer handles:
- Homebrew and CLI tools installation
- ZSH setup with Zinit and plugins
- Neovim configuration and plugin sync
- GNU Stow symlink creation
- Path fixes for your environment

## 📚 Component Documentation

### Core Components
- [**Neovim**](nvim/README.md) - Text editor with LSP, plugins, and DevOps tools
- [**ZSH**](zsh/README.md) - Shell with aliases, functions, and performance features
- [**Git**](git/README.md) - Version control configuration and aliases
- [**Kitty**](kitty/README.md) - Terminal emulator configuration
- [**Atuin**](atuin/README.md) - Advanced shell history

### Development Tools
- [**Go**](go/README.md) - Go development environment
- [**Broot**](broot/README.md) - Tree view and file navigation
- [**Ripgrep**](ripgrep/README.md) - Text search configuration
- [**LSD**](lsd/README.md) - Modern ls replacement

### System Tools
- [**Btop**](btop/README.md) - System monitor
- [**Ghostty**](ghostty/README.md) - GPU-accelerated terminal
- [**LinearMouse**](linearmouse/README.md) - Mouse configuration

### Utilities
- [**Scripts**](scripts/README.md) - Automation scripts and utilities
- [**Scratchpad**](scratchpad/README.md) - Notes and temporary files

## 🔄 Sync Between Machines

Synchronize dotfiles across machines:

```bash
~/dotfiles/scripts/sync.sh
```

This script:
- Pulls latest changes from git
- Runs `brew bundle` to sync packages
- Re-stows all configurations

### Workflow

**Adding new tools:**
```bash
brew install new-tool
cd ~/dotfiles
brew bundle dump --force
git add .
git commit -m "Add new-tool"
git push
```

**Syncing to other machines:**
```bash
~/dotfiles/scripts/sync.sh
```

## 💡 Tips

- Run `./scripts/health-check.sh` after installation to verify setup
- Use `./scripts/benchmark.sh` to check shell startup performance
- See component READMEs for detailed configuration options
- Backup configs with `./scripts/backup-configs.sh` before major changes

