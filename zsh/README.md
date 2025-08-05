# ZSH Configuration Guide

A comprehensive, performance-optimized ZSH configuration with modern tools integration, fuzzy search capabilities, and productivity-focused aliases and functions.

## 📋 Table of Contents

- [Overview](#overview)
- [Files Structure](#files-structure)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Aliases Reference](#aliases-reference)
- [Functions Reference](#functions-reference)
- [File Search Workflows](#file-search-workflows)
- [Git Workflows](#git-workflows)
- [Advanced Usage](#advanced-usage)
- [Performance Features](#performance-features)
- [Troubleshooting](#troubleshooting)
- [Customization](#customization)

## 🎯 Overview

This ZSH configuration is built for developers who want:
- **Lightning-fast shell startup** with lazy-loading optimizations
- **Powerful file search** with ripgrep, fd, and fzf integration
- **Git-aware workflows** with interactive branch/commit browsing
- **Modern tool integrations** (Docker, Kubernetes, Node.js, Python)
- **Cross-platform compatibility** (macOS, Linux)
- **Performance-first approach** with minimal overhead

## 📁 Files Structure

```
zsh/
├── .zshrc          # Main configuration with performance optimizations
├── .zshenv         # Environment variables and PATH setup
├── .zsh_aliases    # Comprehensive alias definitions
├── .zsh_functions  # Custom functions and utilities
├── .p10k.zsh       # Powerlevel10k theme configuration
└── README.md       # This documentation
```

## 🔧 Dependencies

### Required Tools
```bash
# Core tools (install via Homebrew)
brew install zsh fd fzf ripgrep bat lsd zoxide

# Optional but recommended
brew install eza tree ncdu neovim powerlevel10k
```

### ZSH Plugins (Oh-My-Zsh)
- `git` - Git integration and aliases
- `zsh-autosuggestions` - Command suggestions
- `you-should-use` - Alias reminders
- `zsh-syntax-highlighting` - Command syntax highlighting

## 🚀 Installation

1. **Install dependencies:**
   ```bash
   brew bundle --file=~/dotfiles/Brewfile
   ```

2. **Install Oh-My-Zsh:**
   ```bash
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Install ZSH plugins:**
   ```bash
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
   ```

4. **Symlink configuration files:**
   ```bash
   cd ~/dotfiles
   stow zsh
   ```

5. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```

## ⚡ Quick Start

### Essential Commands to Try

```bash
# File search with preview
ff              # Find files with syntax highlighting
f               # Basic file finder

# Text search
rgf "function"  # Find files containing "function"
rgi "TODO"      # Interactive search for "TODO"

# Directory navigation
fzd             # Navigate directories with preview
zz              # Jump to recent directories
fcd             # Change to directory (basic)

# Git workflows
fzg             # Browse git files
fzc             # Browse git commits
fzb             # Browse git branches
```

## 📚 Aliases Reference

### 🚀 Navigation
| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `~` | `cd ~` | Go to home directory |
| `c` | `clear` | Clear terminal |

### 📂 Directory Listing
| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -lah` | Long format with hidden files |
| `la` | `ls -A` | List all except . and .. |
| `l` | `ls -CF` | Compact view with indicators |
| `lls` | `lsd` | Modern ls with icons |
| `lll` | `lsd -l` | Long format with lsd |
| `lla` | `lsd -la` | Long format with hidden files |
| `llt` | `lsd --tree` | Tree view |

### 🔍 File Search & Navigation
| Alias | Command | Description |
|-------|---------|-------------|
| `f` | `fd ... \| fzf` | Basic file finder |
| `ff` | Enhanced file search | File search with preview |
| `fzf` | Enhanced fzf | File finder with bat preview |
| `fzf-files` | Enhanced fzf | Files with right preview panel |
| `fcd` | `cd $(fd ... \| fzf)` | Change directory fuzzy |
| `fzd` | Enhanced directory nav | Directory nav with preview |
| `zz` | `zoxide query -l \| fzf` | Recent directories |

### 🔎 Text Search
| Alias | Command | Description |
|-------|---------|-------------|
| `rg` | `rg --color=always ...` | Enhanced ripgrep |
| `rgf` | ripgrep + fzf | Find files containing text |
| `rgi` | Interactive ripgrep | Interactive text search |

### 📝 Editor Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `v` | `nvim` | Open Neovim |
| `vi` | `nvim` | Open Neovim |
| `vim` | `nvim` | Open Neovim |

### 🐳 Docker
| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `docker` | Docker shortcut |
| `dc` | `docker compose` | Docker Compose |
| `dps` | `docker ps` | List containers |
| `dim` | `docker images` | List images |

### 🌐 Network
| Alias | Command | Description |
|-------|---------|-------------|
| `myip` | `curl -s ipinfo.io/ip` | Show public IP |
| `ports` | `netstat -tulanp` | List open ports |
| `pingg` | `ping 8.8.8.8` | Ping Google DNS |
| `flushdns` | Flush DNS cache | macOS DNS flush |

### ⏳ Process Management
| Alias | Command | Description |
|-------|---------|-------------|
| `psg` | `ps aux \| grep -i` | Search processes |
| `kill9` | `kill -9` | Force kill process |

### 📦 Package Management
| Alias | Command | Description |
|-------|---------|-------------|
| `bi` | `brew install` | Install package |
| `bu` | `brew update && brew upgrade` | Update packages |
| `bs` | `brew search` | Search packages |

### 🔥 Configuration Management
| Alias | Command | Description |
|-------|---------|-------------|
| `ez` | `nvim ~/.zshrc` | Edit ZSH config |
| `rz` | `source ~/.zshrc` | Reload ZSH config |
| `cez` | `code ~/.zshrc` | Open ZSH in VS Code |
| `czenv` | `code ~/.zshenv` | Open env config |
| `cea` | `code ~/.zsh_aliases` | Open aliases |
| `cef` | `code ~/.zsh_functions` | Open functions |

### 🏠 Project Navigation
| Alias | Command | Description |
|-------|---------|-------------|
| `@dot` | `cd $HOME/dotfiles` | Go to dotfiles |
| `@dev` | `cd $HOME/Developer` | Go to dev folder |
| `@workspace` | `cd $WORKSPACE` | Go to workspace |
| `@kodex` | `cd $WORKSPACE/kodex` | Go to kodex |
| `@goprojs` | `cd $WORKSPACE/kodex/go-projects` | Go to Go projects |

### 👻 Ghostty Terminal
| Alias | Command | Description |
|-------|---------|-------------|
| `gt` | `ghostty-theme` | Change theme |
| `gta` | `ghostty-auto-theme` | Auto theme by time |
| `gts` | `ghostty-sync-system` | Sync with system |
| `gtl` | List themes | List available themes |
| `gp` | `ghostty-profile` | Switch profiles |
| `gconf` | Edit config | Edit Ghostty config |

## 🛠️ Functions Reference

### 📦 File Operations
#### `extract <file>`
Universal archive extractor supporting multiple formats.
```bash
extract archive.tar.gz    # Extract tar.gz
extract file.zip          # Extract zip
extract data.7z           # Extract 7z
```

#### `mkcd <directory>`
Create directory and change into it.
```bash
mkcd new-project          # Create and enter directory
```

#### `up [number]`
Go up N directory levels.
```bash
up          # Go up 1 level (same as cd ..)
up 3        # Go up 3 levels
```

### 🔍 System Utilities
#### `diskusage`
Show disk usage for current directory.
```bash
diskusage   # Show top 20 largest items
```

#### `biggestfiles [depth]`
Find largest files with optional depth limit.
```bash
biggestfiles     # Search 3 levels deep (default)
biggestfiles 5   # Search 5 levels deep
```

#### `killproc <process_name>`
Safely kill processes by name with confirmation.
```bash
killproc node        # Kill all node processes
killproc "Chrome"    # Kill Chrome processes
```

### 🌐 Network Functions
#### `isup <url>`
Check if website is accessible.
```bash
isup google.com      # Check Google
isup github.com      # Check GitHub
```

#### `pingtest <host>`
Enhanced ping test with better output.
```bash
pingtest 8.8.8.8     # Ping Google DNS
pingtest github.com  # Ping GitHub
```

#### `fastdns [domain]`
Test DNS lookup speed across multiple servers.
```bash
fastdns              # Test google.com (default)
fastdns github.com   # Test specific domain
```

### 📦 Package Management
#### `brewupdate`
Update Homebrew packages with progress feedback.
```bash
brewupdate           # Update, upgrade, and clean
```

#### `sysupdate`
Cross-platform system update.
```bash
sysupdate           # Updates packages on macOS/Linux
```

### 🐳 Docker Functions
#### `docker-clean`
Remove stopped Docker containers.
```bash
docker-clean        # Clean up stopped containers
```

#### `docker-rmi`
Remove all Docker images with confirmation.
```bash
docker-rmi          # Remove all images (with prompt)
```

### ⏳ Productivity
#### `timer <seconds>`
Countdown timer with system notification.
```bash
timer 300           # 5-minute timer
timer 25            # 25-second timer (shows countdown)
```

#### `now`
Show current time in multiple formats.
```bash
now                 # Show local and UTC time
```

### 🐙 Git Functions
#### `fzg`
Browse and select Git-tracked files with preview.
```bash
fzg                 # Interactive git file browser
```

#### `fzc`
Browse Git commits with diff preview.
```bash
fzc                 # Interactive commit browser
```

#### `fzb`
Browse Git branches with commit history preview.
```bash
fzb                 # Interactive branch browser
```

#### `ghopen`
Open current Git repository in browser.
```bash
ghopen              # Open GitHub repo in browser
```

#### `gitst`
Enhanced git status with better formatting.
```bash
gitst               # Show git status with icons
```

### 👻 Ghostty Functions
#### `ghostty-theme <theme>`
Change Ghostty terminal theme.
```bash
ghostty-theme nord           # Switch to Nord theme
ghostty-theme solarized-light # Switch to light theme
```

#### `ghostty-auto-theme`
Automatically switch theme based on time of day.
```bash
ghostty-auto-theme          # Dark at night, light during day
```

#### `ghostty-profile <profile>`
Switch between terminal profiles.
```bash
ghostty-profile coding      # Coding profile
ghostty-profile presentation # Presentation profile
ghostty-profile minimal     # Minimal profile
```

### 🔧 Development Tools
#### `benchmark-shell`
Benchmark shell startup time.
```bash
benchmark-shell     # Test startup performance
```

#### `test-completion [directory]`
Test ZSH completion behavior.
```bash
test-completion     # Test current directory
test-completion ~   # Test home directory
```

#### `reload-completions`
Reload ZSH completion system.
```bash
reload-completions  # Fix completion issues
```

## 🔍 File Search Workflows

### Basic File Finding
```bash
# Find any file quickly
f                   # Basic file finder
ff                  # Enhanced with preview

# Find specific file types
fd '\.js$'          # Find JavaScript files
fd '\.py$'          # Find Python files
fd 'config'         # Find files with 'config' in name
```

### Content Search
```bash
# Find files containing specific text
rgf "function"      # Files containing "function"
rgf "TODO|FIXME"    # Files with TODO or FIXME
rgi "error"         # Interactive search for "error"

# Search with context
rg -A 3 -B 3 "function"  # Show 3 lines before/after
rg -C 5 "class"          # Show 5 lines of context
```

### Directory Navigation
```bash
# Navigate to directories
fzd                 # Browse directories with preview
fcd                 # Basic directory change
zz                  # Jump to recent directories (zoxide)

# Quick project navigation
@dot                # Go to dotfiles
@dev                # Go to development folder
@workspace          # Go to workspace
```

### Git-Aware Search
```bash
# In Git repositories
fzg                 # Browse only Git-tracked files
fzc                 # Browse commits with diff
fzb                 # Browse branches with history

# Git file operations
git ls-files | fzf  # Manual git file browsing
```

## 🔀 Git Workflows

### Interactive Git Operations
```bash
# Browse and select files
fzg                 # Select from git-tracked files
# → Use Ctrl+/ to toggle preview
# → Use Ctrl+U/D for preview navigation

# Browse commit history
fzc                 # Interactive commit browser
# → See full diff in preview
# → Copy commit hash

# Branch management
fzb                 # Browse branches with history
# → See recent commits for each branch
# → Switch to selected branch
```

### Quick Git Operations
```bash
# Status and overview
gitst               # Enhanced git status
ghopen              # Open repo in browser

# Combined workflows
fzg | xargs nvim    # Open selected git files in editor
fzc | cut -d' ' -f1 | xargs git show  # Show selected commit
```

## 🚀 Advanced Usage

### FZF Key Bindings
| Key | Action |
|-----|--------|
| `Ctrl+/` | Toggle preview window |
| `Ctrl+U` | Preview page up |
| `Ctrl+D` | Preview page down |
| `Ctrl+T` | File finder (global) |
| `Alt+C` | Directory finder (global) |
| `Ctrl+R` | History search (global) |

### Combining Tools
```bash
# Find and edit files
ff | xargs nvim                    # Edit selected files
rgf "TODO" | cut -d: -f1 | xargs nvim  # Edit files with TODOs

# Find and operate on directories
fzd | xargs ls -la                 # List contents of selected dir
fzd | xargs du -sh                 # Check size of selected dir

# Git + file operations
fzg | xargs git add                # Stage selected files
fzc | cut -d' ' -f1 | xargs git cherry-pick  # Cherry-pick commits
```

### Environment Customization
```bash
# Custom FZF options
export FZF_DEFAULT_OPTS='--height 50% --border'

# Custom ripgrep config
echo "--hidden" >> ~/.config/.ripgreprc
echo "--glob=!*.log" >> ~/.config/.ripgreprc

# Custom fd options
alias myfd='fd --hidden --no-ignore'
```

## ⚡ Performance Features

### Lazy Loading
- **NVM**: Loaded only when Node.js tools are used
- **Conda**: Initialized only when conda command is called
- **kubectl**: Completions loaded on first use

### Startup Optimizations
- **Completion caching**: Rebuilds only when needed
- **PATH optimization**: Minimal external calls
- **Plugin selection**: Only essential plugins loaded
- **Syntax highlighting**: Loaded last for better performance

### Benchmarking
```bash
benchmark-shell     # Test shell startup time
profile-zsh         # Profile startup components
```

## 🐛 Troubleshooting

### Common Issues

#### Slow Shell Startup
```bash
# Check startup time
benchmark-shell

# Profile what's taking time
profile-zsh

# Disable plugins temporarily
# Edit .zshrc and comment out plugins
```

#### FZF Not Working
```bash
# Check if fd is installed
which fd

# Reinstall fzf
brew reinstall fzf

# Check FZF environment variables
echo $FZF_DEFAULT_COMMAND
```

#### Completions Not Working
```bash
# Reload completions
reload-completions

# Reset completion cache
reset-comp

# Test completion
test-completion
```

#### Git Functions Failing
```bash
# Check if in git repository
git status

# Verify git is properly configured
git config --list
```

### Performance Troubleshooting
```bash
# Check what's in your PATH
echo $PATH | tr ':' '\n'

# Profile zsh startup
zsh -xvs < /dev/null

# Check for slow plugins
# Temporarily disable plugins in .zshrc
```

## 🎨 Customization

### Adding Custom Aliases
Edit `~/.zsh_aliases`:
```bash
# Add your custom aliases
alias myalias='my command'
alias projectcd='cd /path/to/project'
```

### Adding Custom Functions
Edit `~/.zsh_functions`:
```bash
# Add your custom functions
my_function() {
  echo "Custom function"
}
```

### Environment Variables
Edit `~/.zshenv`:
```bash
# Add your environment variables
export MY_VAR="value"
export PATH="$PATH:/my/custom/path"
```

### FZF Customization
```bash
# Custom preview commands
export FZF_CTRL_T_OPTS='--preview "my-preview-command {}"'

# Custom key bindings
export FZF_DEFAULT_OPTS='--bind ctrl-a:select-all'
```

### Theme Customization
The configuration uses Powerlevel10k. Customize with:
```bash
p10k configure      # Interactive configuration
nvim ~/.p10k.zsh    # Manual configuration
```

---

## 📚 Additional Resources

- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh)
- [FZF Documentation](https://github.com/junegunn/fzf)
- [Ripgrep User Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)
- [fd Documentation](https://github.com/sharkdp/fd)
- [Powerlevel10k Configuration](https://github.com/romkatv/powerlevel10k)

---

*This configuration is optimized for developer productivity and performance. Feel free to customize it according to your needs!*