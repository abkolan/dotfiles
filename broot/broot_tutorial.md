# Broot Quick Start Tutorial

## What is Broot?
Broot is a new way to navigate directories, designed to get you where you need to go with the minimum keystrokes. It's especially powerful for large codebases.

## Installation & Setup
```bash
# Install broot
brew install broot

# Source the br function in your shell (already added to your .zshrc)
source ~/.zshrc

# Verify it works
br --version
```

## Essential Commands

### 1. Basic Navigation
```bash
br                    # Start broot in current directory
br ~/projects         # Start in specific directory
```

Inside broot:
- **↑/↓** - Navigate up/down
- **→** - Enter directory / open file preview
- **←** - Go back to parent
- **Enter** - Open file in editor (or cd to directory with br)
- **Alt+Enter** - cd to selected directory (when using br)
- **Esc** - Cancel/go back

### 2. Search & Filter

#### File Search (Default)
Just start typing to filter files:
```
config        # Fuzzy search for "config"
/\.js$        # Regex: all .js files  
e/README      # Exact match for README
```

#### Content Search
```
c/TODO        # Search "TODO" in file contents
rc/func.*main # Regex content search
```

#### Search Modes
- **Default** - Fuzzy path search
- **/** prefix - Regex search
- **e/** prefix - Exact search
- **c/** prefix - Content search

### 3. File Preview & Operations

#### Preview
- **Space** - Toggle file preview
- **Ctrl+→** - Open preview panel

#### File Operations
```
:cp newname      # Copy file
:mv newname      # Move/rename file
:rm              # Delete file
:e               # Edit in $EDITOR
```

### 4. Git Integration

With git flag enabled (`-g`):
- See git status indicators on files
- **Alt+G** - Toggle git filter
- **:gf** - Show only git-modified files

### 5. Directory Size & Sorting

```
:ss              # Sort by size
:sd              # Sort by date
:sn              # Sort by name
:sc              # Sort by count (number of files)
```

### 6. Advanced Features

#### Staging (Mark Multiple Files)
- **Ctrl+G** - Toggle staging for file
- **:stage_all** - Stage all visible files
- **:unstage_all** - Unstage all
- Then apply operations to staged files

#### Panels (Split View)
- **Ctrl+→** - Open/focus right panel
- **Ctrl+←** - Open/focus left panel
- Great for copying between directories

#### Execute Commands
```
:!ls -la         # Run shell command
:!git status     # Check git status
:{cmd} {file}    # Use {file} placeholder
```

## Your Custom Shortcuts

Based on your config:
- **Alt+H** - Toggle hidden files
- **Alt+F** - Toggle fold/unfold directories  
- **Ctrl+E** - Edit file
- **Ctrl+T** - Open terminal here
- **Ctrl+B** - Create backup copy

## Power User Workflows

### 1. Quick Directory Jump
```bash
br
# Type partial directory name
# Alt+Enter to cd there
```

### 2. Find & Delete node_modules
```
node_modules
:rm
# Confirms deletion of all node_modules folders
```

### 3. Find Large Files
```
:ss              # Sort by size
:toggle_hidden   # Include hidden files
# Navigate to see what's using space
```

### 4. Project File Search
```bash
br ~/projects/myapp
# Type filename to find it instantly
# Enter to edit
```

### 5. Clean Build Artifacts
```
target/ :rm      # Rust
build/ :rm       # Generic
dist/ :rm        # JavaScript
*.pyc :rm        # Python bytecode
```

### 6. Quick Git Status Check
```
:gf              # Filter to modified files only
:!git diff       # See actual changes
```

## Pro Tips

1. **Use br, not broot** - The `br` function lets you actually cd to directories

2. **Type to filter** - Just start typing, no need for special commands

3. **Tab completion** - Tab completes commands and paths

4. **Escape cancels** - Hit Esc multiple times to go back/cancel

5. **Help is `:?`** - Shows all available commands

6. **Combine flags** - `br -hg` for hidden files + git info

7. **Use panels** - Ctrl+→ for two-panel mode makes copying easier

8. **Content search is powerful** - `c/TODO|FIXME` finds all todos and fixmes

## Cheat Sheet

| Key/Command | Action |
|------------|--------|
| `br` | Start broot (with cd capability) |
| Just type | Filter files |
| `/pattern` | Regex search |
| `c/text` | Search in file contents |
| **Space** | Preview file |
| **Alt+Enter** | cd to directory |
| **Alt+H** | Toggle hidden files |
| **Alt+F** | Collapse/expand all |
| **Ctrl+G** | Stage/unstage file |
| `:ss` | Sort by size |
| `:rm` | Delete |
| `:e` | Edit |
| `:q` | Quit |

## Your Configuration

Your broot is configured with:
- Hidden files shown by default (`-h` flag)
- Kitty keyboard support enabled
- Dark-blue skin theme
- Custom verbs for Alt+H and Alt+F

To further customize, edit:
- `~/.config/broot/conf.hjson` - Main config
- `~/.config/broot/verbs.hjson` - Keyboard shortcuts