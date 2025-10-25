# 📊 Btop Configuration

## Overview
[Btop](https://github.com/aristocratos/btop) is a resource monitor that shows usage and stats for processor, memory, disks, network and processes. It's a modern replacement for htop with a beautiful TUI interface.

## Features
- Real-time CPU, memory, disk, and network monitoring
- Process management with kill, priority adjustment
- Mouse support
- Responsive UI with vim-style navigation
- Temperature monitoring (if sensors available)

## Installation
```bash
# Install btop
brew install btop

# Symlink configuration (handled by stow)
cd ~/dotfiles
stow btop
```

## Configuration Location
Configuration is stored in `~/.config/btop/btop.conf` after first run.

## Usage
```bash
btop            # Launch btop

# Keyboard shortcuts
h               # Toggle help
q/ESC           # Quit
f               # Filter processes
t               # Toggle tree view
k/↑             # Move up
j/↓             # Move down
Enter           # Show process details
d/Delete        # Kill process
Space           # Pause updates
+ -             # Select CPU cores
1-4             # Toggle boxes (cpu/mem/net/proc)
```

## Customization
The configuration file allows customization of:
- Color themes
- Update frequency
- Graph style
- Network interface selection
- Temperature units (C/F)