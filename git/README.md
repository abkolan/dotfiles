# Git Configuration

## Overview
Custom Git configuration for improved workflow, better diffs, and convenient aliases. Includes global gitignore patterns and enhanced diff/merge tools.

## Features
- Custom aliases for common operations
- Enhanced diff visualization with delta
- Global gitignore for system files
- Improved merge conflict resolution
- Better log formatting
- Rebase on pull by default

## Installation
```bash
# Symlink configuration
cd ~/dotfiles
stow git
```

## Configuration Files
- `.gitconfig` - Main Git configuration with user info and includes
- `.gitconfig.d/aliases` - All Git aliases
- `.gitconfig.d/tools` - Tool configurations (delta, etc.)

## 📋 Git Aliases

### Status and Info
| Alias | Command | Description |
|-------|---------|-------------|
| `git st` | `status -sb` | Compact status view |
| `git ll` | `log --oneline --graph --decorate -15` | Quick log with graph (15 commits) |
| `git lg` | Pretty formatted log | Log with graph, colors, and commit info |
| `git last` | `log -1 HEAD` | Show last commit |

### Workflow
| Alias | Command | Description |
|-------|---------|-------------|
| `git co` | `checkout` | Checkout branch/commit |
| `git br` | `branch` | Branch operations |
| `git cm` | `commit -m` | Commit with message |
| `git cam` | `commit -am` | Add all and commit |
| `git unstage` | `reset HEAD --` | Unstage files |

### Advanced
| Alias | Command | Description |
|-------|---------|-------------|
| `git find` | `log --grep` | Find commits by message |
| `git cleanup` | Branch cleanup | Remove merged branches (excludes main/master/develop) |

### Diff Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `git d` | `diff` | Show unstaged changes |
| `git dc` | `diff --cached` | Show staged changes |

### Branch Management
| Alias | Command | Description |
|-------|---------|-------------|
| `git brd` | `branch -d` | Delete branch (safe) |
| `git brD` | `branch -D` | Force delete branch |

### Stash Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `git s` | `stash` | Stash changes |
| `git sp` | `stash pop` | Apply and remove stash |
| `git sl` | `stash list` | List all stashes |

### Remote Operations
| Alias | Command | Description |
|-------|---------|-------------|
| `git f` | `fetch` | Fetch from remote |
| `git fo` | `fetch origin` | Fetch from origin |
| `git p` | `push` | Push to remote |
| `git pl` | `pull` | Pull from remote (rebases by default) |

### Rebase
| Alias | Command | Description |
|-------|---------|-------------|
| `git rb` | `rebase` | Rebase current branch |
| `git rbi` | `rebase -i` | Interactive rebase |
| `git rbc` | `rebase --continue` | Continue rebase |
| `git rba` | `rebase --abort` | Abort rebase |

## 🎨 Delta Integration

If delta is installed, provides:
- Syntax highlighting in diffs
- Line numbers
- Side-by-side view option
- Improved merge conflict display

Install delta:
```bash
brew install git-delta
```

## ⚙️ Configuration Highlights

### Pull Behavior
```
[pull]
rebase = true
```
All pulls perform rebase instead of merge for cleaner history.

### Credential Helper
Uses `git-credential-manager` for secure credential storage.

## Tips

- Use `git st` for quick status checks
- Use `git lg` for visual commit history
- Use `git cleanup` to remove merged feature branches
- Configure default branch: `git config --global init.defaultBranch main`
- Set up commit signing: `git config --global commit.gpgsign true`
- Use `git find "keyword"` to search commit messages
