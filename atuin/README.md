# ⚡ Atuin Configuration

## Overview
[Atuin](https://github.com/ellie/atuin) replaces the default shell history with a SQLite database-backed system providing powerful fuzzy search, sync capabilities, and privacy filtering. It enhances history search (Ctrl+R) with context-aware features and statistics.

## Features
- Fuzzy search through unlimited command history
- SQLite database for fast queries
- Privacy filtering (auto-detects and filters secrets)
- Cross-machine sync (optional)
- Command statistics and analytics
- Context-aware search (directory, time, host filtering)
- Preserves original shell navigation (arrow keys still work)

## Installation
```bash
# Install atuin
brew install atuin

# Symlink configuration
cd ~/dotfiles
stow atuin
```

Configuration is automatically loaded via `.zshrc` initialization.

## Configuration Files
- `config.toml` - Main atuin configuration with performance and privacy settings

## Usage

### Basic Search
```bash
# Interactive search (replaces Ctrl+R)
Ctrl+R              # Open fuzzy search interface
h                   # Quick search alias
```

### Search Interface Keybindings
| Key | Action |
|-----|--------|
| `Ctrl+R` | Open search |
| `Type` | Fuzzy search |
| `↑/↓` or `Ctrl+P/N` | Navigate results |
| `Enter` | Execute command |
| `Tab` | Insert without executing |
| `Ctrl+D` | Delete entry |
| `Esc` | Cancel |

### Search Filters
```bash
# Basic search
docker                           # Find docker commands

# Advanced filters
:host laptop                     # Commands from specific host
:cwd /project                    # Commands in directory
:before 2024-01-01              # Before date
:after 2024-01-01               # After date

# Combined filters
docker :after 2024-01-01 :cwd /work
```

### Statistics
```bash
hs                  # Overall command statistics
hsd                 # Today's stats
hsw                 # This week's stats
hsm                 # This month's stats
```

### History Management
```bash
hi                  # Import existing shell history
hsync               # Manual sync
hclean              # Clean up duplicates
```

## Configuration Highlights

### Performance
- `update_check = false` - Faster startup
- `max_history_length = 100000` - Extensive history
- `inline_height = 25` - Optimized for standard terminals

### Privacy Features
- Automatic secret filtering (passwords, tokens, API keys)
- Directory-based filtering (`/tmp`, `/private`, etc.)
- Command pattern filtering (noise commands excluded)

### Filtered Commands
The following commands are not saved to history:
- Navigation: `cd`, `ls`, `ll`, `pwd`, `..`, `...`
- Utilities: `clear`, `exit`, `c`, `l`
- Job control: `fg`, `bg`, `jobs`

### Secret Patterns
Auto-filtered patterns include:
- `password=*`, `token=*`, `api_key=*`
- Bearer tokens
- SSH keys
- AWS credentials

## Tips
- Use Tab to insert command for editing without executing
- Combine filters for precise searches
- Use `:cwd` filter to find project-specific commands
- Stats help identify workflow patterns

