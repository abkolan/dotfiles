# 🌲 Broot Configuration

## Overview
[Broot](https://github.com/Canop/broot) is a new way to navigate directory trees, designed to get you where you need to go with minimal keystrokes. This configuration optimizes broot for use with Kitty terminal and includes custom keybindings.

## Features
- **Hidden files shown by default** - No need to toggle visibility
- **Kitty keyboard protocol enabled** - Full keyboard support in Kitty terminal  
- **Custom keybindings**:
  - `Alt+H` - Toggle hidden files
  - `Alt+F` - Toggle fold/unfold all directories
  - `Ctrl+E` - Edit file in $EDITOR
  - `Ctrl+T` - Open terminal in current directory
- **Dark-blue theme** - Optimized for dark terminals

## Installation
```bash
# Install broot
brew install broot

# Symlink configuration (handled by stow)
cd ~/dotfiles
stow broot
```

## Configuration Files
- `conf.hjson` - Main configuration
- `verbs.hjson` - Custom commands and keybindings
- `skins/` - Color themes

## Usage
```bash
# Use br function to change directories
br              # Start in current directory
br ~/projects   # Start in specific directory

# Inside broot
/pattern        # Regex search
c/text          # Search in file contents
:ss             # Sort by size
:sd             # Sort by date
```

## Tips
- Use `br` instead of `broot` to enable directory changing on exit
- Just start typing to filter files (no command needed)
- Press Space to preview files
- Use Alt+Enter to cd to selected directory