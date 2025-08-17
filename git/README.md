# Git Configuration

## Overview
Custom Git configuration for improved workflow, better diffs, and convenient aliases. Includes global gitignore patterns and enhanced diff/merge tools.

## Features
- Custom aliases for common operations
- Enhanced diff visualization with delta
- Global gitignore for system files
- Improved merge conflict resolution
- Better log formatting
- Commit signing setup (if configured)

## Installation
```bash
# Symlink configuration (handled by stow)
cd ~/dotfiles
stow git
```

## Configuration Files
- `.gitconfig` - Main Git configuration
- `.gitignore_global` - Global ignore patterns

## Common Aliases
```bash
git st          # status
git co          # checkout
git br          # branch
git ci          # commit
git unstage     # reset HEAD --
git last        # log -1 HEAD
git visual      # log graph visualization
git amend       # commit --amend
```

## Delta Integration
If delta is installed, provides:
- Syntax highlighting in diffs
- Line numbers
- Side-by-side view option
- Improved merge conflict display

## Global Gitignore
Automatically ignores:
- `.DS_Store` (macOS)
- `*.swp`, `*.swo` (Vim)
- `.idea/` (JetBrains IDEs)
- `node_modules/`
- `__pycache__/`
- `.env` files

## Tips
- Use `git config --global --edit` to modify global config
- Set up commit signing: `git config --global commit.gpgsign true`
- Configure default branch: `git config --global init.defaultBranch main`