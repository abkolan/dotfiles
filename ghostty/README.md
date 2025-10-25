# 👻 Ghostty Configuration

## Overview
[Ghostty](https://github.com/mitchellh/ghostty) is a fast, feature-rich, and cross-platform terminal emulator written in Zig. It focuses on performance and correctness while providing modern terminal features.

## Features
- GPU-accelerated rendering
- Native performance (written in Zig)
- Ligature support
- True color support
- Excellent emoji rendering
- macOS native integration

## Installation
```bash
# Install Ghostty (when publicly available)
# Currently in private beta - check https://ghostty.org

# Symlink configuration (handled by stow)
cd ~/dotfiles
stow ghostty
```

## Configuration Location
Configuration should be placed in `~/.config/ghostty/config`

## Key Features
- Minimal input latency
- Zero-frame rendering
- Native OS integration
- Font ligatures and fallback
- Hyperlink support (OSC 8)

## Configuration Options
Common settings to customize:
```
font-family = "JetBrains Mono"
font-size = 14
theme = "catppuccin-mocha"
background-opacity = 0.95
cursor-style = "block"
```

## Usage
```bash
ghostty         # Launch Ghostty

# Common shortcuts (macOS)
Cmd+T           # New tab
Cmd+W           # Close tab
Cmd+D           # Split pane
Cmd+Shift+D     # Close pane
```

## Notes
Ghostty is designed to be a modern replacement for terminals like Alacritty and Kitty, with focus on:
- Native performance without sacrificing features
- Correct terminal emulation
- Minimal configuration with sensible defaults