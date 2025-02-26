# abkolan's dotfiles 🔧

A collection of configuration files for my development environment, managed with GNU Stow.

## Overview

This repository contains my personal dotfiles for various tools and applications I use daily in my development workflow. The configurations are organized to work with [GNU Stow](https://www.gnu.org/software/stow/), which creates symlinks from this repository to your home directory.

## ⚠️ Warning

⚠️ **Use at your own risk!** These configuration files are tailored to my personal setup and may not work for everyone. Make sure to review and understand the changes before applying them to your system.

## Tools & Configurations

### Window Manager
- [**i3**](https://i3wm.org/) - A tiling window manager for X11

### Terminal & Shell
- [**zsh**](https://www.zsh.org/) - Extended Bourne shell with many improvements
  - `.p10k.zsh` - Configuration for [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
  - `.zsh_aliases` - Custom shell aliases
  - `.zsh_functions` - Custom shell functions
  - `.zshenv` - Environment variables
  - `.zshrc` - Main zsh configuration

### Text Editor
- [**Neovim**](https://neovim.io/) - Hyperextensible Vim-based text editor
  - Init configs in both Vim script and Lua
  - Includes plugin management with [lazy.nvim](https://github.com/folke/lazy.nvim)

### Development Tools
- [**git**](https://git-scm.com/) - Distributed version control system
  - `.gitconfig` - Global Git configuration

- [**lsd**](https://github.com/lsd-rs/lsd) - The next gen ls command
  - Modern replacement for `ls` with colorization and icons

- [**ripgrep**](https://github.com/BurntSushi/ripgrep) - A modern replacement for grep
  - Recursively searches directories for a regex pattern

### Utility Scripts
- **Mac-specific scripts**
  - `set_sound_io_studio_display.sh` - Configure audio for Studio Display
  - `switch_audio_source.sh` - Switch between audio sources
  - `toggle_dark_mode.sh` - Toggle macOS dark/light mode
  - `toggle_dock_position.sh` - Toggle Dock position
  
- **Nix-specific scripts**
  - `brightness` - Adjust screen brightness
  - `fuzzy_lock.sh` - Lock screen with blur effect

## Installation

1. Clone this repository to your home directory:
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

3. Use Stow to create symlinks for each configuration:
   ```bash
   cd ~/dotfiles
   stow zsh          # For zsh configuration
   stow nvim         # For Neovim configuration
   stow git          # For git configuration
   # etc...
   ```

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