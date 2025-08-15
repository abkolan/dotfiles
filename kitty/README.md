# Kitty Terminal Configuration

This is a fully optimized Kitty terminal setup for macOS with reading-optimized themes, smart keyboard shortcuts, and Neovim compatibility.

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
- **Dark Theme** (Tomorrow Night)
  - Thin strokes (0.4 gamma) matching iTerm2
  - Optimized for Retina displays
  - Easy on eyes for long coding sessions

- **Light Theme** (GitHub Light)  
  - Normal/thicker strokes (1.7 gamma)
  - High contrast for outdoor use
  - Perfect for bright environments

### Text Rendering
Text thickness automatically adjusts based on theme:
- Dark backgrounds use thin strokes for crispness
- Light backgrounds use thicker strokes for readability

## ⌨️ Keyboard Shortcuts

### Option/Alt Key Configuration
**Current Setting:** `macos_option_as_alt right`
- **Left Option** = macOS word navigation (Option+←/→ for word jumping)
- **Right Option** = Alt key for Neovim plugins

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

### Window Management (Splits/Panes)
| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split vertically (new window to the right) |
| `Cmd+Shift+D` | Split horizontally (new window below) |
| `Cmd+Option+↑/↓/←/→` | Navigate between windows |
| `Cmd+Ctrl+↑/↓/←/→` | Resize current window |
| `Cmd+Shift+W` | Close current window |

### Layout Management
| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+L` | Cycle through layouts |
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
| `Cmd+F` | Search in scrollback |
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

### Window Resizing (NEW)
| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+H` | Make window narrower |
| `Cmd+Shift+L` | Make window wider |
| `Cmd+Shift+K` | Make window taller |
| `Cmd+Shift+J` | Make window shorter |
| `Cmd+Shift+0` | Reset window sizes |

## 📖 Reading Optimizations

### Font & Display Settings
- **Font:** JetBrains Mono Nerd Font 14pt (with ligatures!)
- **Line height:** 120% for comfortable reading
- **Character spacing:** 102% to reduce eye strain
- **Cursor:** Block shape with gentle blink
- **Scrollback:** 10,000 lines
- **Background opacity:** 0.98 (subtle transparency)
- **Tab bar:** Always visible with numbered tabs

### Performance Optimizations (ENHANCED)
- **Reduced repaint delay:** 3ms (was 5ms) - snappier response
- **Reduced input latency:** 1ms - instant typing feedback
- **GPU acceleration:** Enabled with modern fullscreen
- **Sync to monitor:** Disabled for better performance
- **Smooth cursor trails:** For easy tracking
- **Ligatures:** Enabled for beautiful code (=>  !=  >=)

### URL & Link Features (NEW)
- **Auto-detect URLs:** Highlighted with curly underline
- **Click to open:** Cmd+Click any URL
- **URL hints:** Cmd+Shift+U shows all clickable URLs
- **Path hints:** Cmd+Shift+O for file paths

## 📁 Configuration Files

| File | Purpose |
|------|---------|
| `kitty.conf` | Main configuration |
| `current-theme.conf` | Active theme (auto-updated) |
| `themes/tomorrow-night-optimized.conf` | Dark theme |
| `themes/github-light.conf` | Light theme |
| `macos-shortcuts.conf` | All keyboard shortcuts |
| `reading-optimizations.conf` | Display optimizations |
| `theme-specific-settings.conf` | Text rendering guide |

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

1. **Window vs Tab:** Tabs are separate sessions, windows are splits within a tab
2. **URL Opening:** `Cmd+Shift+O` shows clickable hints for all URLs
3. **Font Size:** Changes are temporary unless saved to config
4. **Performance:** Disable cursor trails if using battery power
5. **Neovim Alt Key:** Use Right Option for Alt combinations (e.g., Right Option+H/J/K/L)
6. **Word Navigation:** Left Option+←/→ still works for word jumping as expected

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
- The setup preserves iTerm2 workflow while adding Kitty's advanced features