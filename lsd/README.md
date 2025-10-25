# 📁 LSD Configuration

## Overview
[LSD (LSDeluxe)](https://github.com/lsd-rs/lsd) is a modern replacement for the `ls` command with colors, icons, tree-view, and more. It's like `ls` on steroids.

## Features
- File icons and colors
- Tree view support
- Git integration
- File permissions in human-readable format
- Sorting by size, time, extension
- Symlink visualization

## Installation
```bash
# Install lsd
brew install lsd

# Symlink configuration (handled by stow)
cd ~/dotfiles
stow lsd
```

## Configuration Location
Configuration file: `~/.config/lsd/config.yaml`

## Common Usage
```bash
lsd             # Basic listing
lsd -l          # Long format with details
lsd -la         # Include hidden files
lsd -lh         # Human-readable sizes
lsd -lt         # Sort by modification time
lsd -lS         # Sort by size
lsd --tree      # Tree view
lsd --tree -d 2 # Tree view, max depth 2
```

## Aliases (add to shell config)
```bash
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'
alias ll='lsd -lah'
```

## Configuration Options
Common settings in `config.yaml`:
```yaml
icons:
  when: auto
  theme: fancy
date: relative
size: short
permission: octal
sorting:
  dir-grouping: first
```

## Features Over Standard ls
- **Icons** - Visual file type indicators
- **Colors** - Syntax highlighting for permissions
- **Git status** - Shows git modifications inline
- **Header** - Column headers in long format
- **Tree** - Built-in tree view without `tree` command

## Tips
- Use `--config-file` to test different configurations
- Combine with `bat` for complete modern CLI experience
- Use `--blocks` to customize output columns