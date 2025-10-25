# 🖱️ LinearMouse Configuration

## Overview
[LinearMouse](https://linearmouse.app/) is a macOS app that provides Windows-like mouse acceleration and customization. It allows per-device configuration and fixes macOS's non-linear mouse acceleration curve.

## Features
- Linear mouse acceleration (1:1 movement)
- Per-device configuration
- Separate settings for mouse and trackpad
- Custom scroll direction per device
- Adjustable pointer and scrolling speed
- Disable mouse acceleration entirely

## Installation
```bash
# Install LinearMouse
brew install --cask linearmouse

# Configuration is stored in:
# ~/Library/Preferences/com.lujjjh.LinearMouse.plist

# Symlink configuration (if applicable)
cd ~/dotfiles
stow linearmouse
```

## Key Settings
- **Linear mode** - Provides predictable mouse movement
- **Pointer speed** - Adjust sensitivity without acceleration
- **Scrolling** - Natural or reverse per device
- **Polling rate** - Higher = smoother (125Hz to 1000Hz)

## Configuration Options
Typical settings for gaming/precision:
- Disable acceleration
- Set polling rate to 1000Hz
- Adjust DPI in mouse software
- Use linear curve

For productivity:
- Mild acceleration
- Device-specific profiles
- Different settings for mouse vs trackpad

## Tips
- Test settings in the built-in target practice
- Use different profiles for different mice
- Disable for trackpad if you prefer macOS defaults
- Check "Launch at login" for consistency

## Troubleshooting
- Grant Accessibility permissions in System Settings
- Restart app after macOS updates
- Reset settings: Delete plist file and restart