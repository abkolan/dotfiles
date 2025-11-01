# 🔍 Ripgrep Configuration

## Overview
[Ripgrep (rg)](https://github.com/BurntSushi/ripgrep) is a blazingly fast recursive text search tool that respects .gitignore files and provides excellent performance for code searching.

## Features
- Extremely fast search (faster than ag, ack, grep)
- Respects .gitignore by default
- Smart case sensitivity
- Unicode support
- Regex support with multiple regex engines
- Compressed file search support

## Installation
```bash
# Install ripgrep
brew install ripgrep

# Symlink configuration (handled by stow)
cd ~/dotfiles
stow ripgrep
```

## Configuration Location
Configuration file: `.ripgreprc`
After running `stow ripgrep`, the configuration file will be symlinked to `~/.config/.ripgreprc`, and `ripgrep` will automatically detect it.

## Common Usage
```bash
rg pattern              # Search for pattern
rg -i pattern          # Case insensitive
rg -w word             # Match whole words
rg -n pattern          # Show line numbers
rg -C 3 pattern        # Show 3 lines context
rg -t py pattern       # Search only Python files
rg -T js pattern       # Exclude JavaScript files
rg --files             # List all files rg would search
rg -z pattern          # Search in compressed files
rg -l pattern          # Only show filenames
rg -c pattern          # Count matches
```

## Configuration Options
Common settings in config file:
```
# Add custom types
--type-add=web:*.{html,css,js}

# Set default options
--smart-case
--hidden
--follow
--max-columns=150
--max-columns-preview

# Exclude directories
--glob=!.git
--glob=!node_modules
--glob=!target
--glob=!build
```

## Advanced Features
```bash
# Multiline search
rg -U 'fn.*\{.*\n.*todo'

# Replace text
rg foo --replace bar

# Search specific file types
rg -t rust pattern
rg -t md pattern

# JSON output
rg --json pattern
```

## Integration Tips
- Works great with fzf: `rg --files | fzf`
- Use with vim: `:grep` using rg
- Faster than `git grep` in large repos
- Use `--debug` to understand why files are ignored

## Performance Tips
- Use `--mmap` for better memory usage on large files
- `--threads` to control parallelism
- `--ignore-file` for custom ignore patterns
- Pre-compile regex with `--regex-size-limit`