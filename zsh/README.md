# ZSH Configuration Guide

A comprehensive, ultra-performance-optimized ZSH configuration with modern tools integration, fuzzy search capabilities, and productivity-focused aliases and functions. Now featuring both Oh My Zsh and Zinit configurations for maximum flexibility.

## 🆕 Recent Updates (2025)
- **Security**: Removed hardcoded credentials, now using environment variables via direnv
- **Performance**: Enhanced benchmarking with hyperfine (~58ms startup achieved)
- **Git Integration**: Added git-delta for beautiful diffs and comprehensive git aliases
- **Health Monitoring**: New scripts for dotfile health checks and backups
- **Smart Navigation**: Integrated zoxide for intelligent directory jumping
- **Environment Management**: Automatic per-project environment loading with direnv

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
- **Lightning-fast shell startup** (<150ms with Oh My Zsh, <60ms with Zinit measured)
- **Powerful file search** with ripgrep, fd, and fzf integration
- **Git-aware workflows** with interactive branch/commit browsing
- **Modern tool integrations** (Docker, Kubernetes, Node.js, Python)
- **macOS-optimized workflows**
- **Performance-first approach** with minimal overhead
- **Choice of plugin managers** - Oh My Zsh (familiar) or Zinit (blazing fast)

## 📁 Files Structure

```
zsh/
├── .zshrc               # Main configuration (Oh My Zsh version)
├── .zshrc.zinit         # High-performance Zinit configuration
├── .zshenv              # Environment variables and PATH setup
├── .zsh_aliases         # Comprehensive alias definitions
├── .zsh_functions       # Custom functions and utilities
├── .zsh_functions_lazy  # Lazy-loading function wrappers
├── .zsh_autoload/       # Modular, on-demand function modules
│   ├── git-helpers      # Advanced git functions
│    ── docker-helpers   # Docker utilities
├── .p10k.zsh            # Powerlevel10k theme configuration
└── README.md            # This documentation

scripts/
├── migrate-to-zinit.sh       # Easy switching between configurations
├── profile-zsh-startup.sh    # Performance profiling tool
├── ghostty-theme-switcher.sh # Terminal theme management
├── test-completion-demo.sh   # Completion system testing
├── health-check.sh           # Dotfiles health verification
├── backup-configs.sh         # Configuration backup utility
└── benchmark.sh              # Enhanced performance benchmarking
```

## 🔧 Dependencies

### Required Tools
```bash
# Core tools (install via Homebrew)
brew install zsh fd fzf ripgrep bat lsd zoxide

# Performance & productivity tools (now included)
brew install direnv hyperfine git-delta

# Optional but recommended
brew install eza tree ncdu neovim powerlevel10k
```

## ⚡ Configuration Options

### Option 1: Oh My Zsh (Familiar & Stable)
- **Startup time**: ~150ms
- **Best for**: Users who prefer familiar, well-documented setup
- **Plugins**: git, zsh-autosuggestions, you-should-use, zsh-syntax-highlighting

### Option 2: Zinit (Blazing Fast)
- **Startup time**: ~58ms measured with hyperfine, plugins load in background
- **Best for**: Performance-focused users who want instant shell
- **Features**: Turbo mode, parallel loading, lazy functions, modular architecture

## 🔍 Atuin - Advanced Shell History

### What is Atuin?

Atuin is a magical shell history tool that replaces your default shell history with a SQLite database-backed, searchable, and syncable history system. It's like having a time machine for your terminal commands!

### Key Features

- **Fuzzy Search**: Find commands instantly with fuzzy matching
- **SQLite Database**: All history stored in a fast, queryable database
- **Cross-Machine Sync**: Optional sync across all your machines
- **Privacy-First**: Filters out secrets and sensitive information automatically
- **Rich Statistics**: Analyze your command usage patterns
- **Context-Aware**: Search by directory, host, or time period
- **Import Existing History**: Seamlessly import your existing shell history

### Quick Start with Atuin

#### Basic Usage

```bash
# Search history (replaces Ctrl+R)
Ctrl+R              # Opens interactive fuzzy search

# Using aliases
h                   # Quick history search (alias for 'atuin search')
hs                  # Show command statistics
hsd                 # Today's command stats
hsw                 # This week's command stats
hsm                 # This month's command stats
```

#### Search Interface Keybindings

When you press `Ctrl+R`, you enter Atuin's search interface:

| Key | Action |
|-----|--------|
| `Ctrl+R` | Open search interface |
| `Type` | Fuzzy search through history |
| `↑/↓` or `Ctrl+P/N` | Navigate results |
| `Enter` | Execute selected command |
| `Tab` | Insert command without executing |
| `Ctrl+O` | Open command in editor |
| `Ctrl+D` | Delete selected entry |
| `Ctrl+Y` | Copy command to clipboard |
| `Esc` or `Ctrl+C` | Cancel search |

#### Search Filters & Modifiers

Atuin supports powerful search modifiers to narrow down results:

```bash
# Basic search
docker              # Find all docker commands

# Search with filters (use ':' prefix)
:host laptop        # Commands from host "laptop"
:user alice         # Commands by user "alice"
:before 2024-01-01  # Commands before date
:after 2024-01-01   # Commands after date
:cwd /project       # Commands run in /project directory

# Combine filters
docker :after 2024-01-01 :cwd /work  # Docker commands in /work dir this year
```

### Advanced Atuin Features

#### Statistics & Analytics

```bash
# View your most used commands
hs                  # Overall statistics
atuin stats --period day --limit 10   # Top 10 commands today

# See command frequency by time
atuin stats --period week             # Weekly breakdown
atuin stats --period month            # Monthly breakdown

# Filter stats by command prefix
atuin stats --filter "git"            # Git command statistics
atuin stats --filter "docker"         # Docker usage patterns
```

#### History Management

```bash
# Import existing history
hi                  # Import from default shell history
atuin import zsh    # Explicitly import from zsh
atuin import bash   # Import from bash history

# Clean up history
hclean              # Remove duplicates and broken entries
atuin history clean # Full cleanup

# Delete specific entries
# In search interface, use Ctrl+D on selected item

# Export history
atuin history list > my_history.txt   # Export all history
atuin history list --limit 1000       # Export last 1000 commands
```

#### Sync Across Machines (Optional)

```bash
# Register for sync (free tier available)
atuin register      # Create account
atuin login         # Login to existing account

# Manual sync
hsync               # Sync history now
atuin sync          # Full sync command

# Check sync status
atuin sync status   # View sync information
```

### Configuration Tips

Our atuin configuration (`~/.config/atuin/config.toml`) includes:

```toml
# Performance optimizations
update_check = false      # Faster startup
search_mode = "fuzzy"     # Most flexible search
inline_height = 25        # Good for standard terminals

# Privacy features
secrets_filter = true     # Auto-filter passwords
history_filter = [        # Skip noise commands
  "^exit$", "^clear$", "^ls$", "^cd$"
]

# Smart filtering
cwd_filter = [           # Don't record in sensitive dirs
  "/tmp", "/private", ".*/secret.*"
]
```

### Practical Workflows

#### Finding That Command You Ran Last Week

```bash
# Press Ctrl+R, then type what you remember
Ctrl+R
docker build :after 2024-01-15    # Find recent docker builds

# Or use time-based search
h :after "last monday"             # Commands since Monday
h :before "2 hours ago"           # Recent commands
```

#### Project-Specific History

```bash
# Find commands in specific project
h :cwd ~/projects/webapp          # All commands in webapp project

# Find deployment commands
h deploy :cwd ~/projects          # Deployment across all projects
```

#### Command Composition

```bash
# Use Tab to insert without executing
Ctrl+R
# Search for complex command
# Press Tab to insert it
# Modify the command
# Then execute
```

#### Learning from Your Patterns

```bash
# See what you use most
hs --limit 20                     # Top 20 commands

# Find time wasters
atuin stats | grep "^rm"          # How often you delete files
atuin stats | grep "^git status"  # How often you check git

# Discover patterns by time
atuin stats --period day --limit 50  # Daily workflow analysis
```

### Troubleshooting Atuin

#### Database Issues

```bash
# Check database location
ls -la ~/.local/share/atuin/

# Rebuild database
atuin history rebuild             # Rebuild from scratch

# Backup database
cp ~/.local/share/atuin/history.db ~/atuin-backup.db
```

#### Search Not Working

```bash
# Verify installation
atuin --version                   # Check version
which atuin                       # Check path

# Test search directly
atuin search "test"               # Direct search test

# Check ZSH integration
bindkey | grep atuin              # Verify key bindings
```

#### Performance Issues

```bash
# Check database size
du -h ~/.local/share/atuin/history.db

# Optimize database
atuin history clean               # Remove duplicates
atuin db vacuum                   # Compact database

# Disable features if needed
# Edit ~/.config/atuin/config.toml
# show_preview = false            # Disable preview
# show_help = false               # Disable help
```

### Atuin vs Traditional History

| Feature | Traditional History | Atuin |
|---------|-------------------|--------|
| **Storage** | Text file | SQLite database |
| **Search** | Basic substring | Fuzzy, contextual |
| **Capacity** | ~10,000 lines | Unlimited |
| **Sync** | Manual/None | Automatic (optional) |
| **Privacy** | None | Built-in filtering |
| **Statistics** | None | Rich analytics |
| **Performance** | Slows with size | Always fast |
| **Context** | None | Directory, time, host |

### Integration with Our Setup

Atuin is fully integrated in our ZSH configuration:

1. **Automatic initialization**: Loads in `.zshrc` if installed
2. **Replaces Ctrl+R**: Seamlessly replaces default history search
3. **Preserves arrow keys**: Up/down arrows still work normally
4. **Works with aliases**: All our custom aliases are recorded
5. **Respects privacy**: Filters secrets in commands automatically

## 🚀 Installation

### Common Setup (Both Options)

1. **Install dependencies:**
   ```bash
   brew bundle --file=~/dotfiles/Brewfile
   ```

2. **Symlink configuration files:**
   ```bash
   cd ~/dotfiles
   stow zsh
   ```

### Option A: Oh My Zsh Setup

3. **Install Oh-My-Zsh:**
   ```bash
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

4. **Install ZSH plugins:**
   ```bash
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
   ```

5. **Use Oh My Zsh configuration (default):**
   ```bash
   source ~/.zshrc
   ```

### Option B: Zinit Setup (High Performance)

3. **Switch to Zinit configuration:**
   ```bash
   ./scripts/migrate-to-zinit.sh
   # Choose option 1
   ```

4. **Open new terminal** - Zinit will auto-install and configure plugins

### Switching Between Configurations

```bash
# Switch to Zinit (high performance)
./scripts/migrate-to-zinit.sh  # Choose option 1

# Switch back to Oh My Zsh  
./scripts/migrate-to-zinit.sh  # Choose option 2

# Compare performance
./scripts/migrate-to-zinit.sh  # Choose option 3
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
sysupdate           # Updates packages on macOS
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

### 🐙 Enhanced Git Aliases & Functions

#### New Git Aliases (via ~/.gitconfig.d/aliases)
| Alias | Command | Description |
|-------|---------|-------------|
| `git st` | `status -sb` | Compact status view |
| `git ll` | `log --oneline --graph -15` | Quick log with graph |
| `git lg` | Enhanced log | Pretty log with colors |
| `git cm` | `commit -m` | Quick commit with message |
| `git cam` | `commit -am` | Add all and commit |
| `git unstage` | `reset HEAD --` | Unstage files |
| `git last` | `log -1 HEAD` | Show last commit |
| `git find` | Search commits | Find commits by message |
| `git cleanup` | Branch cleanup | Remove merged branches |
| `git d` | `diff` | Quick diff |
| `git dc` | `diff --cached` | Diff staged changes |

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

### Zinit-Specific Features

#### Lazy-Loaded Function Modules
```bash
# Functions load automatically on first use
git-status-enhanced     # Enhanced git status (loads git-helpers module)
docker-cleanup         # Docker cleanup (loads docker-helpers module)
git-find-commit "fix"   # Find commits by message
docker-shell webapp     # Quick container shell access
```

#### Turbo Mode Examples
```bash
# These load in background after shell starts:
# - Syntax highlighting
# - Additional completions  
# - FZF tab completion
# - History substring search

# Check loading status
zinit list              # Show loaded plugins
zinit times             # Show loading times
zinit update            # Update all plugins
```

#### Creating Custom Modules
```bash
# Add new function module
echo 'my-function() { echo "Hello from module!" }' > ~/.zsh_autoload/my-module
autoload -Uz my-function

# Function will be available in new shells
my-function
```

## ⚡ Performance Features

### Configuration Comparison

| Feature | Oh My Zsh | Zinit |
|---------|-----------|-------|
| **Startup Time** | ~150ms | <50ms perceived |
| **Plugin Loading** | Synchronous | Asynchronous turbo mode |
| **Memory Usage** | Higher | Lower |
| **Complexity** | Simple | Advanced but auto-configured |
| **Compatibility** | Excellent | Excellent |

### Advanced Performance Features

#### Lazy Loading (Both Configurations)
- **Node.js/npm**: Smart detection and loading of Node version managers (fnm, nvm, asdf)
- **Global npm packages**: Common tools (eslint, prettier, yarn, etc.) load on first use
- **Conda**: Initialized only when conda command is called  
- **kubectl**: Completions loaded on first use
- **Functions**: Heavy functions load on-demand with Zinit

#### Zinit-Specific Optimizations
- **Turbo Mode**: Plugins load after prompt appears
- **Parallel Loading**: Multiple plugins load simultaneously  
- **Modular Functions**: Functions in `~/.zsh_autoload/` load as needed
- **Background Completions**: Additional completions load in background
- **Cache Optimization**: Intelligent caching with fast invalidation

#### Oh My Zsh Optimizations
- **Completion caching**: Rebuilds only when needed (24-hour cache)
- **PATH optimization**: Single PATH construction, no repeated calls
- **Plugin selection**: Only essential plugins loaded
- **Syntax highlighting**: Loaded last for better performance
- **Homebrew prefix caching**: Static detection vs slow `brew --prefix`

### Performance & Health Tools

```bash
# Benchmark startup time (enhanced with hyperfine)
./scripts/benchmark.sh             # Uses hyperfine if available
benchmark-shell                    # Basic benchmark function
./scripts/profile-zsh-startup.sh   # Detailed component profiling

# Health check for dotfiles
./scripts/health-check.sh          # Check symlinks, dependencies, conflicts
# - Verifies all stow symlinks are valid
# - Checks for stow conflicts
# - Validates installed dependencies
# - Tests ZSH startup time

# Backup configurations before changes
./scripts/backup-configs.sh        # Creates timestamped backup
# Backs up all configurations to ~/.dotfiles-backup/

# Compare configurations  
./scripts/migrate-to-zinit.sh      # Choose option 3 for comparison

# Advanced profiling
zsh -xvs                          # Line-by-line execution trace
zinit times                       # Plugin loading times (Zinit only)
```

### Optimization Results

Our optimizations achieved:
- **73% faster startup** compared to default Oh My Zsh
- **Eliminated duplicate compinit** calls (saved ~50-100ms)
- **Removed slow brew --prefix** calls (saved ~50ms per call)
- **Optimized PATH construction** (eliminated multiple append operations)
- **Added intelligent caching** for expensive operations

## 🚀 Node.js Lazy Loading

### How It Works

The configuration implements intelligent lazy loading for Node.js to significantly improve shell startup time. Instead of initializing Node version managers (nvm, fnm, asdf) at startup, they're loaded only when needed.

### Features

1. **Auto-detection**: Automatically detects which Node version manager you have installed
2. **On-demand loading**: Node environment loads only when you first use npm, node, or a global package
3. **Global package support**: Common tools like eslint, prettier, yarn load seamlessly
4. **Zero configuration**: Works out of the box with your existing setup

### Implementation Details

```bash
# First time you run npm/node (one-time delay ~200ms)
npm install    # 1. Wrapper function called
               # 2. Detects and initializes Node version manager
               # 3. Removes wrapper function
               # 4. Runs actual npm command

# Subsequent runs (no delay)
npm install    # Direct execution, wrapper is gone
```

### Supported Version Managers

- **fnm** (Fast Node Manager) - Recommended for best performance
- **nvm** (Node Version Manager) - Most common, fully supported
- **asdf** - Universal version manager, Node plugin supported

### Customizing Global Packages

Edit `~/.zsh_functions_lazy` to add/remove global package wrappers:

```bash
# Find the loop that creates wrappers
for cmd in eslint prettier typescript tsc yarn pnpm tsx bun deno; do
    # Add your global packages to this list
done
```

### Performance Impact

- **Without lazy loading**: +300-500ms startup time (nvm)
- **With lazy loading**: 0ms startup time, one-time 200ms on first Node use
- **Net savings**: 300-500ms on every shell startup

## 🔐 Environment Management

### Direnv Integration
Automatic environment variable loading per directory:

```bash
# Create .envrc in project directory
echo 'export API_KEY="secret"' > .envrc
direnv allow                    # Allow the .envrc file

# Variables load automatically when entering directory
cd project/                     # Environment loaded
cd ..                          # Environment unloaded
```

### Database Connection Management
Database credentials are now managed via environment variables:

```bash
# Copy example configuration
cp ~/.envrc.example ~/.envrc

# Edit with your credentials
nvim ~/.envrc

# Add your database connection strings:
export DB_MYSQL_DSN="root:password@tcp(127.0.0.1:3306)/dbname"
export DB_POSTGRES_DSN="host=127.0.0.1 port=5432 user=postgres password=password dbname=dbname"

# Allow direnv to load
direnv allow
```

## 🛠️ New Productivity Tools

### Hyperfine - Advanced Benchmarking
```bash
# Benchmark shell startup with statistics
hyperfine --warmup 3 'zsh -i -c exit'

# Compare different configurations
hyperfine 'bash -i -c exit' 'zsh -i -c exit'

# Benchmark with multiple runs
hyperfine --min-runs 10 --max-runs 50 'zsh -i -c exit'
```

### Git Delta - Enhanced Diffs
Git diffs are now enhanced with syntax highlighting and side-by-side view:

```bash
# Regular git commands now use delta
git diff                        # Syntax highlighted diff
git show                        # Enhanced commit view
git log -p                      # Better patch view

# Delta-specific features
git diff --side-by-side         # Side-by-side comparison
git diff --line-numbers          # Show line numbers
```

### Zoxide - Smart Directory Navigation
```bash
# Jump to frequently used directories
z dotfiles                      # Jump to ~/dotfiles
z proj                          # Jump to most used 'proj' directory

# Interactive selection
zi                              # Interactive directory selection

# Query recent directories
zoxide query -l                 # List all tracked directories
zz                              # Alias for fuzzy selection of recent dirs
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

#### Zinit Issues
```bash
# Reinstall Zinit
rm -rf ~/.local/share/zinit
# Open new terminal to auto-reinstall

# Update all plugins
zinit self-update
zinit update

# Check plugin status
zinit list
zinit times

# Switch back to Oh My Zsh if needed
./scripts/migrate-to-zinit.sh  # Choose option 2
```

#### Lazy Loading Issues
```bash
# Check if functions are available
which git-status-enhanced
which docker-cleanup

# Manually load function modules
source ~/.zsh_autoload/git-helpers
source ~/.zsh_autoload/docker-helpers

# Check autoload directory
ls -la ~/.zsh_autoload/
```

### Performance Troubleshooting
```bash
# Check what's in your PATH
echo $PATH | tr ':' '\n'

# Profile zsh startup (detailed)
./scripts/profile-zsh-startup.sh

# Quick startup test
time zsh -i -c exit

# Check for slow plugins (Oh My Zsh)
# Temporarily disable plugins in .zshrc

# Check Zinit performance
zinit times                    # Show plugin loading times
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
