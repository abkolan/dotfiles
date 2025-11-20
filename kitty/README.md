# 🐱 Kitty Terminal Configuration

Fully optimized Kitty terminal setup for macOS with reading-optimized themes, smart keyboard shortcuts, and Neovim compatibility.

## Overview

- Dual-theme workflow with instant toggles and automatic stroke weight adjustments
- macOS-first keybindings that preserve native text navigation while unlocking Neovim Alt combos
- Display tweaks for long-form reading and Retina panels (line height, spacing, cursor)
- Modular configuration split across ".conf" files for easy experimentation

## ✨ Recent Refinements (2025)

### Configuration Improvements
- **Resolved inconsistencies** between main config and reading-optimizations.conf
- **Optimized scrollback** from 50,000 to 10,000 lines for better memory usage
- **Balanced performance** settings (8ms repaint, 2ms input) for optimal responsiveness without excessive CPU
- **Enabled sync to monitor** to prevent screen tearing during scrolling

### New Features
- **Enhanced font rendering** with JetBrains Mono features (+zero for dotted zero, +cv14 for better ampersand)
- **Desktop notifications** for long-running commands (30+ seconds)
- **Window close confirmation** prevents accidental closure of multiple tabs/windows
- **Fuzzy search** in scrollback with fzf (falls back to less if fzf not installed)

### New Keyboard Shortcuts
- **Tab organization:** Cmd+Shift+←/→ to move tabs left/right
- **Window management:** Cmd+Option+1-9 to jump to specific windows (like tab jumping)
- **Window detachment:** Cmd+Shift+N to detach window to new tab
- **Session management:** Cmd+Ctrl+S to save session, Cmd+Ctrl+L for session info

## Prerequisites

- Install Kitty via Homebrew: `brew install --cask kitty`
- Install JetBrains Mono Nerd Font (handled during `./install.sh`, or grab from [nerdfonts.com](https://www.nerdfonts.com/font-downloads))
- Ensure the shared shell helpers from this repo are loaded (`.zsh_functions_lazy`) so the theme aliases are available

## Setup

```bash
cd ~/dotfiles
stow kitty              # symlinks ~/.config/kitty -> ~/dotfiles/kitty/.config/kitty
kitty +kitten themes     # optional: preview shipped themes
```

After stowing, reload Kitty (`Ctrl+Shift+F5`) to pick up changes. Any edits under `~/dotfiles/kitty/.config/kitty` immediately apply to `~/.config/kitty/`.

## Directory Layout

| Path | Purpose |
|------|---------|
| `kitty/.config/kitty/kitty.conf` | Main configuration hub that includes the other modules |
| `kitty/.config/kitty/current-theme.conf` | Auto-generated file for the active theme |
| `kitty/.config/kitty/themes/*.conf` | Optimized dark/light theme definitions |
| `kitty/.config/kitty/macos-shortcuts.conf` | All keyboard shortcuts grouped by feature |
| `kitty/.config/kitty/reading-optimizations.conf` | Rendering tweaks for long sessions |
| `kitty/.config/kitty/theme-specific-settings.conf` | Gamma and text composition overrides per theme |

## 🎨 Theme System

### Quick Theme Commands
After sourcing `.zsh_functions_lazy` or restarting your shell:

| Command | Description |
|---------|-------------|
| `dark` | Apply Tomorrow Night theme with thin strokes |
| `light` | Apply GitHub Light theme with normal strokes |
| `tt` | Toggle between dark/light themes |
| `theme` | Interactive theme selector |
| `kitty-theme` | Browse all available themes |

### Theme Features
**Dark Theme** (Tomorrow Night)
- Thin strokes (0.4 gamma) matching iTerm2
- Optimized for Retina displays
- Easy on eyes for long coding sessions

**Light Theme** (GitHub Light)
- Normal/thicker strokes (1.7 gamma)
- High contrast for outdoor use
- Perfect for bright environments

Text thickness automatically adjusts based on theme (dark backgrounds use thin strokes, light backgrounds use thicker strokes).

## ⌨️  Keyboard Shortcuts

### Option/Alt Key Configuration
**Current Setting:** `macos_option_as_alt right`
- **Left Option:** macOS word navigation (Option+←/→ for word jumping)
- **Right Option:** Alt key for Neovim plugins

This setup preserves your macOS workflow while providing Alt functionality for Neovim.

### Tab Management
| Shortcut | Action |
|----------|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab |
| `Cmd+1-9` | Jump to tab 1-9 |
| `Cmd+Shift+]` | Next tab |
| `Cmd+Shift+[` | Previous tab |
| `Cmd+Shift+T` | Set tab title |
| `Cmd+Shift+←/→` | **NEW:** Move tab left/right |

### Window Management (Splits/Panes)
| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split vertically (new window to the right) |
| `Cmd+Shift+D` | Split horizontally (new window below) |
| `Cmd+Option+↑/↓/←/→` | Navigate between windows |
| `Cmd+Option+1-9` | **NEW:** Jump to specific window (like tabs) |
| `Cmd+Ctrl+↑/↓/←/→` | Resize current window |
| `Cmd+Shift+W` | Close current window |
| `Cmd+Shift+N` | **NEW:** Detach window to new tab |

### Layout Management
| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+L` | Next layout |
| `Cmd+Shift+Z` | Toggle stack layout |
| `Cmd+Shift+P` | Toggle tall layout |
| `Cmd+Shift+F` | Toggle fat layout |

### Text Operations
| Shortcut | Action |
|----------|--------|
| `Cmd+C` | Copy |
| `Cmd+V` | Paste |
| `Cmd+A` | Select all |
| `Cmd+Plus/Minus` | Increase/decrease font size |
| `Cmd+0` | Reset font size |

### Navigation & Scrolling
| Shortcut | Action |
|----------|--------|
| `Cmd+↑/↓` | Page up/down |
| `Cmd+Home/End` | Scroll to top/bottom |
| `Option+↑/↓` | Line by line scrolling |
| `Cmd+F` | **ENHANCED:** Fuzzy search in scrollback with fzf |
| `Cmd+K` | Clear screen and scrollback |

### Advanced Features
| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+U` | Open URL hints |
| `Cmd+Shift+O` | Open file path hints |
| `Cmd+Shift+E` | Unicode/emoji input |
| `Cmd+Ctrl+Space` | Unicode input |
| `Cmd+Shift+R` | Reload config |
| `Cmd+Enter` | Toggle fullscreen |
| `Cmd+Ctrl+S` | **NEW:** Save current session |
| `Cmd+Ctrl+L` | **NEW:** Load session info |

### Window Resizing (Vim-style)
| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+H` | Make window narrower |
| `Cmd+Shift+K` | Make window taller |
| `Cmd+Shift+J` | Make window shorter |
| `Cmd+Shift+0` | Reset window sizes |

## 📖 Reading Optimizations

### Font & Display Settings
- **Font:** JetBrains Mono Nerd Font 14pt (with ligatures)
- **Font features:** Enhanced zero with dot (+zero) and better ampersand (+cv14) for improved character distinction
- **Line height:** 120% for comfortable reading
- **Character spacing:** 102% to reduce eye strain
- **Cursor:** Block shape with gentle blink
- **Scrollback:** 10,000 lines (optimized from 50,000 for better performance)
- **Background opacity:** 0.98 (subtle transparency)
- **Tab bar:** Always visible with numbered tabs
- **Window close confirmation:** Prevents accidental closure when multiple tabs/windows are open

### Performance Optimizations
- **Balanced repaint delay:** 8ms (good balance of responsiveness and CPU usage)
- **Low input latency:** 2ms (very responsive typing feedback)
- **GPU acceleration:** Enabled with modern fullscreen
- **Sync to monitor:** Enabled to prevent screen tearing
- **Smooth cursor trails:** For easy tracking
- **Ligatures:** Enabled for beautiful code (`=>`, `!=`, `>=`)
- **Desktop notifications:** Shows notification when long-running commands finish (30+ seconds)

### URL & Link Features
- **Auto-detect URLs:** Highlighted with curly underline
- **Click to open:** Cmd+Click any URL
- **URL hints:** Cmd+Shift+U shows all clickable URLs
- **Path hints:** Cmd+Shift+O for file paths

## 📁 Configuration Files

`kitty.conf` sits at the root of the config directory and includes the other modules so they stay small and focused:

```
include current-theme.conf
include macos-shortcuts.conf
include reading-optimizations.conf
include theme-specific-settings.conf
```

- Theme files live under `themes/` and are swapped by the helper aliases (`dark`, `light`, `tt`).
- `current-theme.conf` is rewritten automatically by the theme switcher; expect it to show up as modified after toggling themes.
- Keep custom overrides in their own `.conf` and add another `include` so changes stay merge-friendly.

## 🔧 Customization Tips

### Adjusting Text Thickness
Edit `text_composition_strategy` in kitty.conf:
```bash
# Thinner text (dark themes)
text_composition_strategy 0.4 0

# Normal text (light themes)
text_composition_strategy 1.7 0

# Extra bold (high glare)
text_composition_strategy 2.2 0
```

### Changing Alt Key Behavior
Current configuration uses Right Option as Alt. Other options:
```bash
# Current: Right Option as Alt (preserves Left Option for macOS)
macos_option_as_alt right

# Alternative: Left Option as Alt (if you prefer)
macos_option_as_alt left

# Both Options as Alt (lose all macOS navigation)
macos_option_as_alt both

# Disable Alt key entirely
macos_option_as_alt no
```

### Creating Custom Themes
1. Run `kitty +kitten themes` to browse themes
2. Export a theme: `kitty +kitten themes --dump-theme "Theme Name" > my-theme.conf`
3. Edit colors in the exported file
4. Apply with: `cp my-theme.conf current-theme.conf`

## 🚀 Quick Start

1. **Apply changes:** Press `Ctrl+Shift+F5` in Kitty
2. **Test themes:** Type `tt` to toggle dark/light
3. **Check shortcuts:** Press `Ctrl+Shift+F1` to see all active shortcuts
4. **Adjust Alt key:** Edit `macos_option_as_alt` in kitty.conf if needed

## 💡 Pro Tips

- **Window vs Tab:** Tabs are separate sessions, windows are splits within a tab
- **URL Opening:** Cmd+Shift+O shows clickable hints for all URLs
- **Font Size:** Changes are temporary unless saved to config
- **Performance:** Disable cursor trails if using battery power
- **Neovim Alt Key:** Use Right Option for Alt combinations (e.g., Right Option+H/J/K/L)
- **Word Navigation:** Left Option+←/→ still works for word jumping as expected

## 🐛 Troubleshooting

**Theme not applying?**
- Press `Ctrl+Shift+F5` to reload
- Restart Kitty if needed

**Alt key not working in Neovim?**
- Use Right Option key for Alt combinations
- Check `macos_option_as_alt` is set to `right`
- Test with: In Neovim insert mode, press `Ctrl+V` then `Right Option+key`

**Text too thin/thick?**
- Adjust `text_composition_strategy` value
- Lower = thinner, higher = thicker

**Shortcuts conflicting?**
- Check with `Ctrl+Shift+F1`
- Edit `macos-shortcuts.conf` to customize

## 📝 Notes

- Configuration is symlinked via GNU Stow
- Changes in `~/dotfiles/kitty/` automatically apply to `~/.config/kitty/`
- Setup preserves iTerm2 workflow while adding Kitty's advanced features
