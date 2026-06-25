# ZSH Configuration Guide

A comprehensive, performance-optimized ZSH configuration managed by chezmoi. Built around Zinit for fast plugin management, Powerlevel10k for instant prompts, and a modular file structure that keeps startup time under 60ms while providing a rich set of aliases, functions, and integrations.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Load Order](#load-order)
- [Performance](#performance)
- [Plugin Management (Zinit)](#plugin-management-zinit)
- [Aliases Reference](#aliases-reference)
- [Functions Reference](#functions-reference)
- [Completions System](#completions-system)
- [Key Shortcuts and Keybindings](#key-shortcuts-and-keybindings)
- [Atuin Shell History](#atuin-shell-history)
- [FZF Integration](#fzf-integration)
- [Environment Variables](#environment-variables)
- [Tips and Common Workflows](#tips-and-common-workflows)
- [Troubleshooting](#troubleshooting)

---

## Architecture Overview

### File Structure

```
~/ (managed by chezmoi as dot_* in ~/dotfiles)
├── .zshenv              # Environment variables, PATH, FZF config
├── .zshrc               # Main shell config (Zinit-based, primary)
├── .zshrc.zinit         # Alternate Zinit config (legacy reference)
├── .zsh_aliases         # All alias definitions
├── .zsh_functions       # Eagerly loaded shell functions
├── .zsh_functions_lazy  # Lazy-loaded functions (Node.js, Kitty, dev tools)
├── .zsh_completions     # Advanced completion configuration
├── .zsh_autoload/       # On-demand autoloaded function modules
│   ├── docker-helpers   # Docker utility functions
│   └── git-helpers      # Advanced git functions
├── .p10k.zsh            # Powerlevel10k theme (full config)
└── .p10k-minimal.zsh    # Powerlevel10k theme (minimal variant)
```

### Chezmoi Source Mapping

| Chezmoi source file | Target file |
|---|---|
| `dot_zshenv.tmpl` | `~/.zshenv` |
| `dot_zshrc` | `~/.zshrc` |
| `dot_zshrc.zinit` | `~/.zshrc.zinit` |
| `dot_zsh_aliases` | `~/.zsh_aliases` |
| `dot_zsh_functions` | `~/.zsh_functions` |
| `dot_zsh_functions_lazy` | `~/.zsh_functions_lazy` |
| `dot_zsh_completions` | `~/.zsh_completions` |
| `dot_zsh_autoload/` | `~/.zsh_autoload/` |
| `dot_p10k.zsh` | `~/.p10k.zsh` |
| `dot_p10k-minimal.zsh` | `~/.p10k-minimal.zsh` |

Note: `dot_zshenv.tmpl` is a chezmoi template (uses `{{ .chezmoi.homeDir }}` for portable paths like the Granted autocompletion fpath entries).

---

## Load Order

Understanding the load order is critical for debugging and performance tuning. ZSH sources files in a specific sequence, and this configuration layers on top of that.

### 1. `.zshenv` (every ZSH invocation -- login, non-login, scripts)

- Sets `WORKSPACE`, `EDITOR`, `VISUAL`, `LANG`, `LC_ALL`
- Configures Homebrew environment variables (`HOMEBREW_NO_ANALYTICS`, `HOMEBREW_NO_AUTO_UPDATE`)
- Runs `typeset -U PATH` to prevent duplicates
- Builds PATH from scratch: system defaults, then Homebrew via `brew shellenv`, then Go, Cargo, Bun, dotfiles scripts
- Configures all `FZF_*` environment variables with system-appearance-aware color themes
- Sets `RIPGREP_CONFIG_PATH`, `LESS`, `SSH_AUTH_SOCK` (1Password agent)
- Adds Granted autocompletion to `fpath`
- Defines the `assume` alias for Granted AWS

### 2. `.zshrc` (interactive shells only)

Executed in this order:

1. **Powerlevel10k instant prompt** -- cached prompt renders immediately before anything else loads
2. **Early exit guards** -- skips init for non-interactive shells and IntelliJ environment reader
3. **Zinit bootstrap** -- auto-installs Zinit if missing, then sources it
4. **Zinit cache config** -- enables plugin caching to `~/.cache/zinit`
5. **Theme** -- loads Powerlevel10k with `depth=1` (shallow clone), sources `~/.p10k.zsh`
6. **Turbo plugins** -- queued to load asynchronously after the prompt appears:
   - `wait'0a'`: OMZ git plugin
   - `wait'0b'`: fast-syntax-highlighting, zsh-autosuggestions
   - `wait'0c'`: zsh-history-substring-search
   - (no wait): zsh-completions (loaded synchronously, blocked from running compinit)
   - `wait'1'`: fzf-tab
7. **Node.js lazy loading** -- sources `.zsh_functions_lazy` (wrapper functions for npm/node/npx/etc.)
8. **Conda lazy loading** -- wrapper function that initializes conda on first use
9. **Broot launcher** -- sources broot shell integration if present
10. **kubectl lazy loading** -- wrapper function with completion on first use
11. **Homebrew prefix** -- dynamic detection and export
12. **Completion system** -- `compinit` with 24-hour cache, compiled dump, minimal styling, fzf-tab styling
13. **Zoxide** -- `zoxide init zsh`
14. **FZF** -- sources `~/.fzf.zsh`
15. **ZSH options** -- history settings, `AUTO_CD`, `INTERACTIVE_COMMENTS`, etc.
16. **Atuin** -- initializes advanced history search, binds Ctrl+R
17. **Aliases** -- sources `.zsh_aliases`
18. **Functions** -- sources `.zsh_functions`
19. **Direnv** -- hooks into the shell for automatic `.envrc` loading
20. **Uv** -- sources `~/.local/bin/env`
21. **AWS CLI** -- bashcompinit and aws_completer

---

## Performance

### Startup Time Target

The configuration targets **under 60ms** startup time (measured with `hyperfine --warmup 3 'zsh -i -c exit'`).

### Key Optimization Strategies

| Strategy | Savings | How |
|---|---|---|
| Powerlevel10k instant prompt | Perceived 0ms | Cached prompt renders before plugins load |
| Zinit turbo mode | ~100ms | Plugins load asynchronously after prompt |
| Lazy Node.js loading | 300-500ms | npm/node/npx are wrapper functions until first use |
| Lazy conda loading | ~200ms | conda initializes only on first `conda` call |
| Lazy kubectl completions | ~100ms | Completions load on first `kubectl` call |
| compinit caching | 50-100ms | Recompiles `.zcompdump` only every 24 hours |
| Homebrew prefix caching | ~50ms | Avoids repeated `brew --prefix` calls |
| `typeset -U PATH` | Varies | Prevents PATH bloat across shell restarts |
| `HOMEBREW_NO_AUTO_UPDATE=1` | Varies | Prevents brew from checking for updates on every install |
| IntelliJ guard | Full skip | Returns immediately for IDE environment readers |

### Benchmarking

```bash
# Quick benchmark (built-in function)
benchmark-shell

# Precise benchmark with hyperfine
hyperfine --warmup 3 'zsh -i -c exit'

# Profile what is slow
profile-zsh

# Zinit plugin timing
zinit times
```

### Lazy Loading Pattern

The configuration uses a consistent pattern for lazy loading expensive tools. A lightweight wrapper function replaces itself with the real tool on first invocation:

```bash
# Example: conda lazy loading (from .zshrc)
conda() {
  unfunction conda 2>/dev/null          # Remove the wrapper
  # ... initialize conda ...
  conda "$@"                            # Call the real conda
}
```

This pattern is used for: **Node.js** (npm, node, npx, and 10 global packages), **conda**, and **kubectl**.

---

## Plugin Management (Zinit)

The configuration uses [Zinit](https://github.com/zdharma-continuum/zinit) exclusively. Oh My Zsh is not required.

### Installed Plugins

| Plugin | Load timing | Purpose |
|---|---|---|
| `romkatv/powerlevel10k` | Immediate (depth=1) | Prompt theme with instant prompt |
| `OMZP::git` | Turbo `wait'0a'` | Git aliases and functions from OMZ |
| `zdharma-continuum/fast-syntax-highlighting` | Turbo `wait'0b'` | Command syntax coloring |
| `zsh-users/zsh-autosuggestions` | Turbo `wait'0b'` | Fish-like autosuggestions |
| `zsh-users/zsh-history-substring-search` | Turbo `wait'0c'` | Up/Down arrow history search |
| `zsh-users/zsh-completions` | Immediate (blockf) | Additional completion definitions |
| `Aloxaf/fzf-tab` | Turbo `wait'1'` | Replace tab completion with fzf |

### Zinit Commands

```bash
zinit list            # Show loaded plugins
zinit times           # Show loading times per plugin
zinit update          # Update all plugins
zinit self-update     # Update Zinit itself
zinit delete <plugin> # Remove a plugin
```

### Autoload Modules

The `~/.zsh_autoload/` directory contains function modules loaded on demand via ZSH's `autoload` mechanism. They are added to `fpath` and autoloaded by the alternate `.zshrc.zinit` configuration.

| Module | Functions provided |
|---|---|
| `docker-helpers` | `docker-cleanup`, `docker-stats`, `docker-shell` |
| `git-helpers` | `git-status-enhanced`, `git-rebase-interactive`, `git-find-commit` |

---

## Aliases Reference

All aliases are defined in `~/.zsh_aliases`. Additional aliases come from the OMZ git plugin loaded via Zinit and from `~/.zsh_functions_lazy`.

### Navigation

| Alias | Expands to | Description |
|---|---|---|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `~` | `cd ~` | Go to home directory |
| `c` | `clear` | Clear terminal |

### Directory Listing

| Alias | Expands to | Description |
|---|---|---|
| `ls` | `ls -G` | Colorized ls (macOS) |
| `ll` | `ls -lah` | Long format, human-readable, hidden files |
| `la` | `ls -A` | All except `.` and `..` |
| `l` | `ls -CF` | Compact with file type indicators |
| `lls` | `lsd` | Modern ls replacement (falls back to `ls`) |
| `lll` | `lsd -l` | Long format via lsd |
| `lla` | `lsd -la` | Long format with hidden files via lsd |
| `llt` | `lsd --tree` | Tree view via lsd |

### Editor Shortcuts

| Alias | Expands to | Description |
|---|---|---|
| `v` | `nvim` | Open Neovim |
| `vi` | `nvim` | Open Neovim |
| `vim` | `nvim` | Open Neovim |

### File Search and Navigation (fzf)

| Alias | Expands to | Description |
|---|---|---|
| `f` | `fd --type f ... \| fzf` | Basic file finder |
| `ff` | `fd ... \| fzf --preview 'bat ...'` | File search with bat preview |
| `fzf-files` | `fd ... \| fzf --preview ...` | Files with right-side preview panel |

### Docker

| Alias | Expands to | Description |
|---|---|---|
| `d` | `docker` | Docker shortcut |
| `dc` | `docker compose` | Docker Compose |
| `dps` | `docker ps` | List running containers |
| `dim` | `docker images` | List images |

### Network

| Alias | Expands to | Description |
|---|---|---|
| `myip` | `curl -s ipinfo.io/ip` | Show public IP address |
| `ports` | `netstat -tulanp` | List open ports |
| `pingg` | `ping 8.8.8.8` | Ping Google DNS |
| `flushdns` | `sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder` | Flush macOS DNS cache |

### Process Management

| Alias | Expands to | Description |
|---|---|---|
| `psg` | `ps aux \| grep -i` | Search for a process |
| `kill9` | `kill -9` | Force kill a process |

### Package Management (Homebrew)

| Alias | Expands to | Description |
|---|---|---|
| `bi` | `brew install` | Install a package |
| `bu` | `brew update && brew upgrade` | Update and upgrade all packages |
| `bs` | `brew search` | Search for packages |

### Python

| Alias | Expands to | Description |
|---|---|---|
| `python` | `python3` | Default to Python 3 |
| `pip` | `pip3` | Default to pip3 |

### Kubernetes

| Alias | Expands to | Description |
|---|---|---|
| `k` | `kubectl` | kubectl shortcut |
| `kctx` | `kubectx` | Switch Kubernetes context |
| `kns` | `kubens` | Switch Kubernetes namespace |
| `kn` | `kubectl config set-context --current --namespace` | Set namespace for current context |

### Git

| Alias | Expands to | Description |
|---|---|---|
| `g` | `git` | Git shortcut |
| `gs` | `git status` | Status |
| `ga` | `git add` | Add files |
| `gc` | `git commit` | Commit |
| `gp` | `git push` | Push |
| `gpl` | `git pull` | Pull |
| `gco` | `git checkout` | Checkout |
| `gb` | `git branch` | Branch |
| `gd` | `git diff` | Diff |

Note: The OMZ git plugin (loaded via Zinit) provides many additional git aliases such as `gst`, `gca`, `gcb`, `glg`, etc. Run `alias | grep git` to see all.

### Configuration Editing

| Alias | Expands to | Description |
|---|---|---|
| `ez` | `nvim ~/.zshrc` | Edit ZSH config in Neovim |
| `rz` | `source ~/.zshrc` | Reload ZSH config |
| `cez` | `code ~/.zshrc` | Edit ZSH config in VS Code |
| `czenv` | `code ~/.zshenv` | Edit zshenv in VS Code |
| `cea` | `code ~/.zsh_aliases` | Edit aliases in VS Code |
| `cef` | `code ~/.zsh_functions` | Edit functions in VS Code |

### Project Navigation

| Alias | Expands to | Description |
|---|---|---|
| `@dot` | `cd $HOME/dotfiles` | Go to dotfiles repo |
| `@dev` | `cd $HOME/Developer` | Go to Developer directory |
| `@workspace` | `cd $WORKSPACE` | Go to workspace (~/repos) |
| `@kodex` | `cd $WORKSPACE/kodex` | Go to kodex directory |
| `@goprojs` | `cd $WORKSPACE/kodex/go-projects` | Go to Go projects |

### Ghostty Terminal

| Alias | Expands to | Description |
|---|---|---|
| `gt` | `ghostty-theme` | Change Ghostty theme |
| `gta` | `ghostty-auto-theme` | Auto theme based on time of day |
| `gts` | `ghostty-sync-system` | Sync theme with macOS appearance |
| `gtl` | `~/dotfiles/scripts/ghostty-theme-switcher.sh --list` | List available themes |
| `gprofile` | `ghostty-profile` | Switch Ghostty profiles |
| `gpc` | `ghostty-profile coding` | Coding profile |
| `gpp` | `ghostty-profile presentation` | Presentation profile |
| `gpm` | `ghostty-profile minimal` | Minimal profile |
| `gpd` | `ghostty-profile default` | Default profile |
| `gconf` | `nvim ~/.config/ghostty/config` | Edit Ghostty config |
| `gthemes` | `nvim ~/.config/ghostty/themes.conf` | Edit Ghostty themes |
| `gprofiles` | `nvim ~/.config/ghostty/profiles.conf` | Edit Ghostty profiles |
| `gt-nord` | `ghostty-theme nord` | Apply Nord theme |
| `gt-dark` | `ghostty-theme one-dark` | Apply One Dark theme |
| `gt-light` | `ghostty-theme solarized-light` | Apply Solarized Light theme |
| `gt-dracula` | `ghostty-theme dracula` | Apply Dracula theme |
| `gt-gruvbox` | `ghostty-theme gruvbox-dark` | Apply Gruvbox Dark theme |
| `gbench` | `ghostty-benchmark` | Run Ghostty performance benchmark |
| `gbackup` | `cp ~/.config/ghostty/config ...backup` | Backup Ghostty config |
| `grestore` | `cp ...backup ~/.config/ghostty/config` | Restore Ghostty config |

### Completion Aliases

| Alias | Expands to | Description |
|---|---|---|
| `test-comp` | `test-completion` | Test completion in current directory |
| `reload-comp` | `reload-completions` | Reload completion system |
| `comp-test` | `test-completion ~` | Test completion in home directory |
| `fix-comp` | `reload-completions` | Fix completion issues |
| `reset-comp` | `rm -f ~/.zcompdump && reload-completions` | Reset and reload completions |

### Node.js

| Alias | Expands to | Description |
|---|---|---|
| `test-node` | `test-nvm` | Test NVM lazy loading |
| `node-v` | `node --version` | Quick Node version check |
| `npm-v` | `npm --version` | Quick NPM version check |
| `nvm-v` | `nvm --version` | Quick NVM version check |
| `nvm-ls` | `nvm list` | List installed Node versions |
| `in` | `_init_node` | Manually initialize Node environment |

### Atuin History

| Alias | Expands to | Description |
|---|---|---|
| `h` | `atuin search` | Quick history search |
| `hs` | `atuin stats` | Show command statistics |
| `hsd` | `atuin stats --period day` | Today's command stats |
| `hsw` | `atuin stats --period week` | This week's command stats |
| `hsm` | `atuin stats --period month` | This month's command stats |
| `hi` | `atuin import auto` | Import existing shell history |
| `hsync` | `atuin sync` | Manual sync |
| `hclean` | `atuin history clean` | Clean up history |

### AI/Code Workflow Shortcuts

| Alias | Expands to | Description |
|---|---|---|
| `pj` | `project` | Fuzzy project switcher |
| `gcm` | `gcommit` | Guided conventional commit |
| `gho` | `ghopen` | Open current repo on GitHub |
| `wtn` | `wtnew` | Create/switch git worktree |
| `wtl` | `wtls` | List/jump git worktrees |
| `wtr` | `wtrm` | Remove git worktree |
| `prn` | `prnow` | Push current branch and open PR |

### Ripgrep

| Alias | Expands to | Description |
|---|---|---|
| `rg` | `rg --color=always --line-number --no-heading --smart-case` | Enhanced ripgrep defaults |

### CKA Exam Shortcuts

| Alias/Export | Value | Description |
|---|---|---|
| `$do` | `--dry-run=client -o yaml` | Dry-run output as YAML |
| `$now` | `--force --grace-period 0` | Force delete immediately |

### Kitty Terminal (from .zsh_functions_lazy)

| Alias | Expands to | Description |
|---|---|---|
| `dark` | Apply Tomorrow Night theme with thin strokes | Dark mode for Kitty |
| `light` | Apply GitHub Light theme with normal strokes | Light mode for Kitty |
| `tt` | `toggle-theme` | Toggle between dark and light in Kitty |

### AWS (from .zshenv template)

| Alias | Expands to | Description |
|---|---|---|
| `assume` | `. assume` | Granted AWS role assumption |

---

## Functions Reference

Functions are split across three files based on loading strategy:

- **`.zsh_functions`** -- sourced eagerly on every shell startup (core functions)
- **`.zsh_functions_lazy`** -- sourced eagerly but contains self-replacing lazy wrappers
- **`.zsh_autoload/`** -- available via ZSH autoload, loaded on first call

### File Operations

| Function | Source | Description |
|---|---|---|
| `extract <file>` | `.zsh_functions` | Universal archive extractor (tar.gz, zip, rar, 7z, xz, bz2) |
| `mkcd <dir>` | `.zsh_functions` | Create directory and cd into it |
| `up [n]` | `.zsh_functions` | Go up N directory levels (default: 1) |
| `trash` | `.zsh_functions_lazy` | Interactive file deletion with fzf preview, moves to trash |
| `bulk_rename` | `.zsh_functions_lazy` | Open current filenames in editor for bulk renaming |
| `backup [source] [dest]` | `.zsh_functions_lazy` | Smart rsync backup excluding .git, node_modules, etc. |

### System Utilities

| Function | Source | Description |
|---|---|---|
| `diskusage` | `.zsh_functions` | Show top 20 largest items in current directory |
| `biggestfiles [depth]` | `.zsh_functions` | Find 10 largest files within depth (default: 3) |
| `killproc <name>` | `.zsh_functions` | Kill processes by name with confirmation prompt |
| `cleanmac` | `.zsh_functions` | Clean macOS caches (user and system) with confirmation |
| `sysinfo` | `.zsh_functions_lazy` | Display OS, CPU, cores, memory, disk, network, uptime |
| `procmon [interval]` | `.zsh_functions_lazy` | Live process monitor (CPU and memory) with refresh interval |
| `memtop` | `.zsh_functions_lazy` | Show top 20 processes by memory usage |
| `diskanalyze [dir]` | `.zsh_functions_lazy` | Disk usage analysis for directory (depth 1) |

### Network

| Function | Source | Description |
|---|---|---|
| `isup <url>` | `.zsh_functions` | Check if a website is reachable (adds https:// if needed) |
| `pingtest <host>` | `.zsh_functions` | Enhanced ping test (5 packets) |
| `fastdns [domain]` | `.zsh_functions` | Compare DNS lookup speed across Google, Cloudflare, OpenDNS |
| `portscan [host] [start] [end]` | `.zsh_functions_lazy` | Scan port range on a host (default: localhost 1-1000) |
| `sslcheck <domain>` | `.zsh_functions_lazy` | Show SSL certificate dates, subject, and issuer |

### Package Management

| Function | Source | Description |
|---|---|---|
| `brewupdate` | `.zsh_functions` | Full Homebrew update + upgrade + cleanup |
| `sysupdate` | `.zsh_functions` | System update (calls brewupdate on macOS) |

### Docker

| Function | Source | Description |
|---|---|---|
| `docker-clean` | `.zsh_functions` | Remove stopped containers |
| `docker-rmi` | `.zsh_functions` | Remove all Docker images with confirmation |
| `docker-cleanup` | `.zsh_autoload/docker-helpers` | Full Docker prune (containers, images, volumes, networks) |
| `docker-stats` | `.zsh_autoload/docker-helpers` | Formatted container stats (name, CPU, memory) |
| `docker-shell [container]` | `.zsh_autoload/docker-helpers` | Interactive shell into container (fzf picker if no arg) |
| `dshell` | `.zsh_functions_lazy` | Interactive container shell via fzf selection |
| `dlogs` | `.zsh_functions_lazy` | Follow container logs via fzf selection |
| `dclean` | `.zsh_functions_lazy` | Full Docker cleanup (stopped, dangling, volumes, networks) |

### Git

| Function | Source | Description |
|---|---|---|
| `ghopen` | `.zsh_functions` | Open current repo on GitHub in browser (SSH/HTTPS aware) |
| `gitst` | `.zsh_functions` | Enhanced git status (short format with branch) |
| `fzg` | `.zsh_functions` | Browse git-tracked files with bat preview |
| `fzc` | `.zsh_functions` | Browse git commits with diff preview |
| `fzb` | `.zsh_functions` | Browse git branches with log preview |
| `git-status-enhanced` | `.zsh_autoload/git-helpers` | Detailed repo status: branch, remote, staged/modified/untracked counts |
| `git-rebase-interactive [n]` | `.zsh_autoload/git-helpers` | Interactive rebase on last N commits (default: 10) |
| `git-find-commit <query>` | `.zsh_autoload/git-helpers` | Search all branches for commits matching query |

### Git Worktrees

| Function | Source | Description |
|---|---|---|
| `wtnew <branch> [base-ref]` | `.zsh_functions` | Create a worktree at `~/.worktrees/<repo>/<branch>` and cd into it |
| `wtls` | `.zsh_functions` | List worktrees with fzf picker to jump between them |
| `wtrm [-f] [branch-or-path]` | `.zsh_functions` | Remove a worktree (fzf picker if no argument; refuses to remove cwd) |
| `prnow [base-branch]` | `.zsh_functions` | Push current branch and create a GitHub PR via `gh pr create --fill` |

### Text Search

| Function | Source | Description |
|---|---|---|
| `rgi <term>` | `.zsh_functions` | Interactive ripgrep search with fzf and bat preview |
| `rgf <term>` | `.zsh_functions` | Find files containing pattern with contextual preview |

### Directory Navigation

| Function | Source | Description |
|---|---|---|
| `fzd` | `.zsh_functions` | Fuzzy directory picker with eza tree preview |
| `fcd` | `.zsh_aliases` | Change to directory selected via fd + fzf |
| `zz` | `.zsh_aliases` | Jump to recent directory via zoxide + fzf |

### Time and Productivity

| Function | Source | Description |
|---|---|---|
| `timer <seconds>` | `.zsh_functions` | Countdown timer with macOS notification on finish |
| `now` | `.zsh_functions` | Show current date/time in local and UTC |
| `note [name]` | `.zsh_functions_lazy` | Open or create a markdown note (default: today's date) |
| `todo [add\|done\|edit\|clear] [task]` | `.zsh_functions_lazy` | Simple todo list manager backed by `~/.todo.md` |

### Ghostty Terminal

| Function | Source | Description |
|---|---|---|
| `ghostty-theme <theme>` | `.zsh_functions` | Change Ghostty theme via sed on config file |
| `ghostty-auto-theme` | `.zsh_functions` | Auto-switch theme: dark (8pm-8am), light otherwise |
| `ghostty-sync-system` | `.zsh_functions` | Sync Ghostty theme to macOS light/dark appearance |
| `ghostty-profile <name>` | `.zsh_functions` | Switch between coding, presentation, minimal, default profiles |
| `ghostty-benchmark` | `.zsh_functions` | Benchmark Ghostty text rendering and scrollback |

### Kitty Terminal

| Function | Source | Description |
|---|---|---|
| `kitty-theme [theme]` | `.zsh_functions_lazy` | Apply a Kitty theme or open interactive browser |
| `toggle-theme` | `.zsh_functions_lazy` | Toggle between dark (Tomorrow Night) and light (GitHub Light) |
| `theme [name]` | `.zsh_functions_lazy` | Interactive menu to pick from favorite Kitty themes |

### Development Tools

| Function | Source | Description |
|---|---|---|
| `benchmark-shell` | `.zsh_functions` | Average 5 startup time measurements |
| `profile-zsh` | `.zsh_functions` | Generate ZSH startup profiling script |
| `test-completion [dir]` | `.zsh_functions` | Show completion settings and directory contents |
| `reload-completions` | `.zsh_functions` | Remove `.zcompdump` and reinitialize completions |
| `test-nvm` | `.zsh_functions` | Test Node.js lazy loading (checks nvm, node, npm) |
| `cc [dir] [-- args]` | `.zsh_functions` | Launch Claude Code, optionally in a target directory |
| `claude-yolo [session-id]` | `.zsh_functions` | Resume a Claude Code session with `--dangerously-skip-permissions` (opens picker if no ID) |
| `cx [dir] [-- args]` | `.zsh_functions` | Launch Codex, optionally in a target directory |
| `project` | `.zsh_functions_lazy` | Fuzzy project finder across workspace/dotfiles/Projects |
| `ghclone <repo> [dest]` | `.zsh_functions_lazy` | Clone a GitHub repo (accepts `user/repo` shorthand) and cd into it |
| `gcommit` | `.zsh_functions_lazy` | Interactive conventional commit (type via fzf, optional scope) |
| `venv [create\|activate\|deactivate]` | `.zsh_functions_lazy` | Python virtual environment manager |
| `gowork [name]` | `.zsh_functions_lazy` | Scaffold a Go project with cmd/pkg/internal and `go mod init` |

### Text Processing

| Function | Source | Description |
|---|---|---|
| `json <file-or-string>` | `.zsh_functions_lazy` | Pretty-print JSON with jq and bat syntax highlighting |
| `csv <file>` | `.zsh_functions_lazy` | View CSV file in aligned columns with less |

### Node.js Lazy Wrappers

| Function | Source | Description |
|---|---|---|
| `_init_node` | `.zsh_functions_lazy` | Detect and initialize fnm, nvm, or asdf |
| `npm`, `node`, `npx` | `.zsh_functions_lazy` | Self-replacing wrappers that call `_init_node` on first use |
| `eslint`, `prettier`, `typescript`, `tsc`, `yarn`, `pnpm`, `tsx`, `bun`, `deno` | `.zsh_functions_lazy` | Self-replacing wrappers for global npm packages |

### Go Override

| Function | Source | Description |
|---|---|---|
| `go` | `.zsh_aliases` | Wraps `go test` to use `richgo` if available; passes other subcommands through |

---

## Completions System

The completions configuration lives in `~/.zsh_completions` and provides an advanced setup on top of ZSH's built-in `compinit`.

### Cache Management

- Completion dump (`.zcompdump`) is recompiled only if older than 24 hours
- A lock file prevents concurrent rebuild by multiple shell instances
- Cache directory: `~/.cache/zsh/completions`

### Completion Styles

| Feature | Configuration |
|---|---|
| Case-insensitive matching | `m:{a-zA-Z}={A-Za-z}` |
| Partial-word matching | `r:\|[._-]=* r:\|=*` and `l:\|=* r:\|=*` |
| Menu selection | Interactive menu with arrow key navigation |
| Colors | Uses `LS_COLORS` for colored listings |
| Group headers | Yellow bold headers for completion categories |
| Warnings | Red "No matches found" message |

### File and Directory Completions

- Special directories (`.` and `..`) included
- Directories listed first
- Files sorted by modification time (newest first)
- Ignored patterns: `*.pyc`, `*.pyo`, `*.bak`, `*~`, `.DS_Store`, `__pycache__`

### Command-Specific Completions

| Command | Enhancement |
|---|---|
| **git** | Custom script, branches sorted by recency, tag ordering (common > all > aliases) |
| **docker** | Option stacking enabled |
| **ssh/scp/sftp/rsync** | Hosts from `~/.ssh/known_hosts` and `~/.ssh/config` |
| **kill** | Color-coded process list with menu selection |
| **man** | Separate sections |
| **npm** | Completes `package.json` script names |
| **make** | Completes Makefile targets |
| **aws** | AWS CLI completer via `aws_completer` |
| **terraform** | Native completion |
| **kubectl** | Lazy-loaded on first use |
| **helm** | Native completion |

### FZF-Tab Integration

When the fzf-tab plugin is loaded (Turbo `wait'1'`), tab completion is replaced with an fzf interface:

- File previews via `bat` with fallback to `eza` and `ls`
- Directory previews via `eza --tree --level=2`
- 50% height, reverse layout, bordered, right-side preview at 60%
- Group switching with `,` and `.`

---

## Key Shortcuts and Keybindings

### Global ZSH Keybindings

| Key | Action | Source |
|---|---|---|
| `Ctrl+R` | Atuin interactive history search (if installed) | `.zshrc` |
| `Ctrl+T` | FZF file finder (fuzzy path completion) | `.zsh_completions` / fzf |
| `Ctrl+G` | Smart cd -- fzf directory picker with eza preview | `.zsh_completions` |
| `Up Arrow` | History substring search up | zsh-history-substring-search |
| `Down Arrow` | History substring search down | zsh-history-substring-search |
| `Tab` | fzf-tab completion (or standard menu completion) | fzf-tab / compinit |
| `Alt+C` | FZF directory finder | fzf |
| `Alt+/` | Complete word from history | `.zsh_completions` |

### FZF Preview Controls

| Key | Action |
|---|---|
| `Ctrl+/` | Toggle preview window (down / hidden / default) |
| `Ctrl+U` | Preview page up |
| `Ctrl+D` | Preview page down |

### Menu Selection Mode (active during tab completion)

| Key | Action |
|---|---|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |
| `Shift+Tab` | Reverse menu complete |

### Atuin Search Interface

| Key | Action |
|---|---|
| `Ctrl+R` | Open search |
| `Up/Down` or `Ctrl+P/N` | Navigate results |
| `Enter` | Execute selected command |
| `Tab` | Insert command without executing |
| `Ctrl+D` | Delete selected entry |
| `Esc` / `Ctrl+C` | Cancel search |

---

## Atuin Shell History

[Atuin](https://github.com/atuinsh/atuin) replaces the default ZSH history with a SQLite-backed, searchable, syncable history system. It is initialized in `.zshrc` if the `atuin` binary is found.

### Configuration

- Initializes with `atuin init zsh --disable-up-arrow` (up/down arrows remain bound to history-substring-search)
- Binds `Ctrl+R` to `_atuin_search_widget`
- ZSH's built-in history (`HISTSIZE=10000`, `SAVEHIST=10000`, `~/.zsh_history`) serves as fallback

### Quick Reference

```bash
h                     # Search history
hs                    # Overall command statistics
hsd                   # Today's stats
hsw                   # This week's stats
hsm                   # This month's stats
hi                    # Import existing shell history
hsync                 # Manual sync across machines
hclean                # Remove duplicates and broken entries
```

---

## FZF Integration

FZF is configured in `.zshenv` for consistency across all shell types.

### Default Settings

- **File finder command**: `fd --type f --hidden --follow --exclude .git`
- **Height**: 40%, reverse layout, bordered
- **Preview window**: right side, 60% width
- **Color theme**: Auto-detected from macOS system appearance (light/dark)

### FZF Environment Variables

| Variable | Purpose |
|---|---|
| `FZF_DEFAULT_COMMAND` | Default file listing command (fd-based) |
| `FZF_DEFAULT_OPTS` | Global options: height, layout, border, preview bindings, colors |
| `FZF_CTRL_T_COMMAND` | File selection trigger (same as default) |
| `FZF_CTRL_T_OPTS` | File selection preview with bat |
| `FZF_ALT_C_COMMAND` | Directory selection command (fd directories) |
| `FZF_ALT_C_OPTS` | Directory preview with eza tree |
| `FZF_CTRL_R_OPTS` | History search preview (hidden by default, toggle with Ctrl+/) |
| `FZF_THEME_COLOR` | Current color palette (light or dark) |

### System Appearance Detection

The FZF color theme automatically matches macOS appearance:

```bash
# From .zshenv -- detected once at shell startup
if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
  FZF_THEME_COLOR="$FZF_COLOR_DARK"
fi
```

---

## Environment Variables

Key environment variables set in `.zshenv`:

| Variable | Value | Purpose |
|---|---|---|
| `WORKSPACE` | `$HOME/repos` | Default workspace root |
| `EDITOR` | `nvim` | Default editor |
| `VISUAL` | `nvim` | Default visual editor |
| `LANG` | `en_US.UTF-8` | Locale |
| `HOMEBREW_NO_ANALYTICS` | `1` | Disable Homebrew telemetry |
| `HOMEBREW_NO_AUTO_UPDATE` | `1` | Prevent auto-update on install |
| `HOMEBREW_AUTO_UPDATE_SECS` | `86400` | Auto-update interval (24h) |
| `RIPGREP_CONFIG_PATH` | `$HOME/.config/.ripgreprc` | Ripgrep configuration file |
| `LESS` | `-R` | Raw control chars in less (for colored output) |
| `SSH_AUTH_SOCK` | `~/.1password/agent.sock` | 1Password SSH agent |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | `64000` | Claude Code token limit |
| `NVM_DIR` | `$HOME/.nvm` | NVM directory |
| `ASDF_DIR` | `$HOME/.asdf` | asdf directory |

### PATH Construction Order

1. System defaults: `/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`
2. Homebrew via `brew shellenv` (Apple Silicon: `/opt/homebrew/...`)
3. macOS cryptex paths (if they exist)
4. Go: `$GOPATH/bin`
5. Cargo: via `~/.cargo/env`
6. Dotfiles scripts: `$HOME/dotfiles/scripts`
7. Bun: `$HOME/.bun/bin`

`typeset -U PATH` at the top guarantees no duplicates regardless of how many times `.zshenv` is sourced.

---

## Tips and Common Workflows

### Find and Edit Files

```bash
# Find a file and open it in Neovim
ff                          # pick a file with preview
v $(ff)                     # open the result in nvim

# Find files containing a pattern and open them
rgf "TODO"                  # pick from files with TODO
```

### Project Switching

```bash
pj                          # fuzzy project finder across all dev directories
@dot                        # jump straight to dotfiles
@workspace                  # jump to workspace
```

### Git Workflows

```bash
# Interactive browsing
fzg                         # browse git-tracked files with preview
fzc                         # browse commits with diff preview
fzb                         # browse branches with log preview

# Conventional commits
gcm                         # guided type + scope + message commit

# Worktrees for parallel work
wtn feature/new-thing       # create worktree and cd into it
wtl                         # list and jump between worktrees
wtr feature/old-thing       # remove a worktree

# Quick PR
prn                         # push and open PR with auto-filled title/body
gho                         # open repo in browser
```

### Docker Workflows

```bash
dshell                      # fzf-pick a running container and shell in
dlogs                       # fzf-pick a container and follow its logs
dclean                      # full Docker resource cleanup
docker-stats                # live container stats table
```

### System Investigation

```bash
sysinfo                     # CPU, memory, disk, network, uptime
procmon                     # live top-processes view
memtop                      # top 20 memory consumers
diskusage                   # top 20 items by size in cwd
biggestfiles 5              # 10 largest files within 5 levels
portscan myhost 80 443      # scan port range
sslcheck example.com        # check SSL certificate details
```

### Quick Notes and Todos

```bash
note                        # open today's note in nvim
note project-ideas          # open a named note
todo                        # view todos
todo add "Review PR #42"    # add a task
todo done "Review PR #42"   # mark done
todo clear                  # remove completed tasks
```

### Node.js

The first time you run `npm`, `node`, `npx`, or any of the wrapped global tools (eslint, prettier, yarn, pnpm, bun, deno, etc.), the shell detects your Node version manager (fnm, nvm, or asdf) and initializes it. Subsequent calls go directly to the real binary with no overhead.

```bash
in                          # manually trigger Node environment init
node-v                      # quick version check
npm-v                       # quick version check
```

### Reloading After Changes

```bash
rz                          # reload .zshrc
reload-comp                 # reload completion system
reset-comp                  # nuke .zcompdump and rebuild completions
```

---

## Troubleshooting

### Slow Shell Startup

```bash
benchmark-shell                        # measure average startup
hyperfine --warmup 3 'zsh -i -c exit'  # precise measurement
profile-zsh                            # generate profiling instructions
zinit times                            # check plugin load times
```

If startup exceeds 100ms, common culprits are:
- Homebrew `brew --prefix` being called (should be cached)
- nvm being sourced eagerly instead of lazily
- compinit running without `-C` flag (cache miss)

### Completions Not Working

```bash
test-comp              # check completion settings
reload-comp            # reload the system
reset-comp             # nuclear option: delete dump and rebuild
```

### FZF Not Showing Previews

Ensure dependencies are installed:

```bash
brew install fd fzf bat eza lsd
```

Check that `FZF_DEFAULT_COMMAND` is set:

```bash
echo $FZF_DEFAULT_COMMAND
# Expected: fd --type f --hidden --follow --exclude .git
```

### Zinit Plugin Issues

```bash
zinit list             # verify plugins are loaded
zinit times            # check for slow plugins
zinit update           # update all plugins
zinit self-update      # update Zinit itself

# Full reset
rm -rf ~/.local/share/zinit
# Open a new terminal -- Zinit will auto-reinstall
```

### Node.js/npm Not Found After Lazy Load

```bash
in                     # manually initialize Node environment
which node             # verify it resolved
```

If the wrapper function did not unfunction properly, check that your version manager (fnm/nvm/asdf) is properly installed.

### Atuin Not Working

```bash
which atuin            # verify installation
atuin --version        # check version
bindkey | grep atuin   # verify keybindings
atuin search "test"    # direct search test
```

---

## Dependencies

### Required

```bash
brew install zsh fd fzf ripgrep bat lsd eza zoxide neovim
```

### Recommended

```bash
brew install direnv hyperfine git-delta jq broot
```

### Optional

```bash
brew install powerlevel10k    # or installed via Zinit (automatic)
brew install kubectx          # for kctx/kns aliases
brew install richgo           # for enhanced go test output
```

### Installed via Other Means

- **Atuin**: `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh`
- **Zinit**: Auto-installed on first shell startup
- **Claude Code / Codex**: Installed separately

---

*This document reflects the actual state of the ZSH configuration files in this repository. If you modify the config files, update this document to match.*
