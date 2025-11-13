# Neovim Configuration

## Overview

Streamlined Neovim setup based on NvChad, optimized for text editing and navigation. Focused on core functionality with essential development tools.

## Features

- Fast navigation with FZF and Telescope
- LSP support with auto-schema validation
- Multi-file management (splits, tabs, buffers)
- DevOps workflows (Terraform, Docker, Go, Python, Helm)
- Mason-managed LSP servers (install quickly via `:MasonInstall`)
- Git integration with diff views
- Markdown preview with Glow

## 🚀 Installation

```bash
# Using GNU Stow
cd ~/dotfiles
stow nvim

# Launch Neovim (plugins install automatically)
nvim
```

## 📦 Dependencies

Required tools:

- **fd** - Fast file finding
- **ripgrep** - Fast text search
- **glow** - Markdown preview
- **Node.js** - LSP servers
- **Python 3** - Python LSP

Install via Homebrew:

```bash
brew install fd ripgrep glow node python
```

## ⌨️ Core Shortcuts

### Essential Navigation

| Shortcut           | Action                  |
| ------------------ | ----------------------- |
| `<C-p>`            | Quick file finder (FZF) |
| `<C-f>`            | Live grep search        |
| `<leader><leader>` | Quick buffer switch     |
| `<leader>e`        | Toggle file tree        |

### Basic Operations

| Shortcut | Action               |
| -------- | -------------------- |
| `;`      | Command mode         |
| `jk`     | Escape (Insert mode) |

## 📁 File Navigation & Search

### Fast File Finding

| Shortcut     | Action                |
| ------------ | --------------------- |
| `<C-p>`      | Quick file finder     |
| `<leader>pf` | Project files (smart) |
| `<leader>pg` | Git tracked files     |
| `<leader>pr` | Recent project files  |

### Telescope Search

| Shortcut     | Action           |
| ------------ | ---------------- |
| `<leader>ff` | Smart find files |
| `<leader>fg` | Live grep        |
| `<leader>fb` | Find buffers     |
| `<leader>fh` | Help tags        |
| `<leader>fo` | Old files        |
| `<leader>fc` | Commands         |
| `<leader>fk` | Keymaps          |

### File Type Searches

| Shortcut      | Action             |
| ------------- | ------------------ |
| `<leader>fey` | Find YAML files    |
| `<leader>fej` | Find JSON files    |
| `<leader>fep` | Find Python files  |
| `<leader>feg` | Find Go files      |
| `<leader>fes` | Find shell scripts |

### FZF-Lua (Fast Alternative)

| Shortcut     | Action        |
| ------------ | ------------- |
| `<leader>Ff` | FZF files     |
| `<leader>Fg` | FZF live grep |
| `<leader>Fb` | FZF buffers   |
| `<leader>Fo` | FZF old files |
| `<leader>Fh` | FZF help      |
| `<leader>Fc` | FZF commands  |
| `<leader>Fk` | FZF keymaps   |

### Advanced Search

| Shortcut     | Action              |
| ------------ | ------------------- |
| `<leader>fG` | Live grep with args |
| `<leader>ft` | Find TODOs          |
| `<leader>ds` | Grep in directory   |
| `<leader>dg` | Grep in git root    |

## 🪟 Multi-File & Window Management

### Window Splitting

| Shortcut      | Action                        |
| ------------- | ----------------------------- |
| `<leader>sv`  | Vertical split                |
| `<leader>sh`  | Horizontal split              |
| `<leader>sfv` | Find file in vertical split   |
| `<leader>sfh` | Find file in horizontal split |
| `<leader>sft` | Find file in new tab          |

### Window Management

| Shortcut     | Action           |
| ------------ | ---------------- |
| `<leader>se` | Equalize windows |
| `<leader>sc` | Close window     |
| `<leader>so` | Only window      |

### Preset Layouts

| Shortcut     | Action                                   |
| ------------ | ---------------------------------------- |
| `<leader>w2` | 2-column layout                          |
| `<leader>w3` | 3-column layout                          |
| `<leader>w4` | 4-window grid                            |
| `<leader>wt` | Open horizontal split sized for terminal |
| `<leader>wT` | Open vertical split sized for terminal   |

### Window Navigation

| Shortcut | Action     |
| -------- | ---------- |
| `<C-h>`  | Move left  |
| `<C-j>`  | Move down  |
| `<C-k>`  | Move up    |
| `<C-l>`  | Move right |

### Window Resizing

| Shortcut    | Action          |
| ----------- | --------------- |
| `<C-Up>`    | Increase height |
| `<C-Down>`  | Decrease height |
| `<C-Left>`  | Decrease width  |
| `<C-Right>` | Increase width  |

## 📂 Directory Navigation

### Quick Directory Access

| Shortcut      | Action                                 |
| ------------- | -------------------------------------- |
| `<leader>dd`  | Navigate to directory (fzf + Neo-tree) |
| `<leader>dcd` | Change directory                       |
| `<leader>dc`  | Files in current dir                   |
| `<leader>dp`  | Files in parent dir                    |
| `<leader>dh`  | Files in home dir                      |
| `<leader>dr`  | Files in git root                      |
| `-`           | Browse parent directory                |
| `_`           | Browse current directory               |

### Quick Directory Jumps

| Shortcut     | Action           |
| ------------ | ---------------- |
| `<leader>d.` | Config directory |
| `<leader>dt` | Temp directory   |
| `<leader>dl` | Log directory    |

### Directory Bookmarks

| Shortcut     | Action           |
| ------------ | ---------------- |
| `<leader>bc` | Config directory |
| `<leader>bn` | Neovim config    |

### Change Working Directory

| Shortcut     | Action                   |
| ------------ | ------------------------ |
| `<leader>cd` | Change to file directory |
| `<leader>cD` | Change to parent         |
| `<leader>ch` | Change to home           |
| `<leader>cw` | Show working directory   |

## 📋 Buffer & Tab Management

### Buffer Operations

| Shortcut     | Action                  |
| ------------ | ----------------------- |
| `<leader>x`  | Delete buffer           |
| `<leader>X`  | Force delete buffer     |
| `]b`         | Next buffer             |
| `[b`         | Previous buffer         |
| `<S-l>`      | Next buffer (quick)     |
| `<S-h>`      | Previous buffer (quick) |
| `<leader>bl` | List buffers            |

### Tab Management

| Shortcut     | Action       |
| ------------ | ------------ |
| `<leader>tn` | New tab      |
| `<leader>tc` | Close tab    |
| `<leader>to` | Only tab     |
| `<leader>tp` | Previous tab |
| `<leader>tN` | Next tab     |
| `<leader>tm` | Move tab     |

### Tab Navigation (Numbers)

| Shortcut    | Action      |
| ----------- | ----------- |
| `<leader>1` | Go to tab 1 |
| `<leader>2` | Go to tab 2 |
| `<leader>3` | Go to tab 3 |
| `<leader>4` | Go to tab 4 |
| `<leader>5` | Go to tab 5 |

## 🎯 LSP & Code Features

### LSP Navigation

| Shortcut | Action               |
| -------- | -------------------- |
| `gd`     | Go to definition     |
| `gD`     | Go to declaration    |
| `gi`     | Go to implementation |
| `gr`     | Show references      |
| `K`      | Hover documentation  |
| `<C-k>`  | Signature help       |

### LSP Actions

| Shortcut     | Action          |
| ------------ | --------------- |
| `<leader>rn` | Rename symbol   |
| `<leader>ca` | Code actions    |
| `<leader>f`  | Format document |

### LSP Telescope Integration

| Shortcut     | Action              |
| ------------ | ------------------- |
| `<leader>fs` | Document symbols    |
| `<leader>fS` | Workspace symbols   |
| `<leader>fr` | LSP references      |
| `<leader>fi` | LSP implementations |
| `<leader>fd` | LSP definitions     |
| `<leader>fD` | Diagnostics         |

### LSP FZF-Lua Integration

| Shortcut     | Action                |
| ------------ | --------------------- |
| `<leader>Fs` | FZF document symbols  |
| `<leader>FS` | FZF workspace symbols |
| `<leader>Fr` | FZF references        |
| `<leader>Fi` | FZF implementations   |
| `<leader>Fd` | FZF definitions       |
| `<leader>FD` | FZF diagnostics       |

### File Outline

| Shortcut     | Action                  |
| ------------ | ----------------------- |
| `<leader>o`  | File outline (symbols)  |
| `<leader>O`  | File outline (detailed) |
| `<leader>wo` | Workspace symbols       |

## 🩺 Diagnostics & Navigation

### Diagnostic Navigation

| Shortcut    | Action              |
| ----------- | ------------------- |
| `[d`        | Previous diagnostic |
| `]d`        | Next diagnostic     |
| `<leader>D` | Show diagnostic     |

### Search Navigation (Centered)

| Shortcut | Action                          |
| -------- | ------------------------------- |
| `n`      | Next search (centered)          |
| `N`      | Previous search (centered)      |
| `*`      | Search word forward (centered)  |
| `#`      | Search word backward (centered) |

### Jump Navigation (Centered)

| Shortcut | Action                  |
| -------- | ----------------------- |
| `<C-o>`  | Jump back (centered)    |
| `<C-i>`  | Jump forward (centered) |

### Reference Navigation

| Shortcut | Action             |
| -------- | ------------------ |
| `]r`     | Next reference     |
| `[r`     | Previous reference |
| `]R`     | Last reference     |
| `[R`     | First reference    |

### Enhanced Symbol Search

| Shortcut    | Action                 |
| ----------- | ---------------------- |
| `<leader>*` | Grep word under cursor |
| `<leader>#` | Grep WORD under cursor |

## 📋 Quickfix & List Management

| Shortcut     | Action                       |
| ------------ | ---------------------------- |
| `<leader>qo` | Open quickfix                |
| `<leader>qc` | Close quickfix               |
| `<leader>qq` | Close quickfix (quick)       |
| `<C-q>`      | Close quickfix (super quick) |

## 🌳 File Explorer (Neo-tree)

| Shortcut     | Action                |
| ------------ | --------------------- |
| `<leader>e`  | Toggle Neo-tree       |
| `<leader>E`  | Focus Neo-tree        |
| `<leader>ef` | Reveal current file   |
| `<leader>ec` | Close Neo-tree        |
| `<leader>er` | Neo-tree file manager |
| `<leader>ge` | Neo-tree git status   |
| `<leader>be` | Neo-tree buffers      |

## 🎨 Git Integration

### Git File Operations

| Shortcut     | Action             |
| ------------ | ------------------ |
| `<leader>gf` | Git files          |
| `<leader>gs` | Git status         |
| `<leader>gl` | Git log            |
| `<leader>gL` | Git buffer commits |
| `<leader>gb` | Git branches       |

### Diffview Integration

| Shortcut     | Action           |
| ------------ | ---------------- |
| `<leader>gd` | Git diff view    |
| `<leader>gh` | Git file history |
| `<leader>gc` | Close diff view  |

## 🔧 Language Support

### Go Development

| Shortcut     | Action          |
| ------------ | --------------- |
| `<leader>gr` | Go run          |
| `<leader>gt` | Go test         |
| `<leader>gi` | Go install deps |

> Use `:GoBuild` and `:GoFmt` (or command palette) for build/format actions—`<leader>gb` and `<leader>gf` are mapped to Git pickers.

### Python Development

| Shortcut     | Action     |
| ------------ | ---------- |
| `<leader>pt` | Run pytest |

> Run the current buffer with `:!python %` when needed—`<leader>pr` is reserved for recent project files.

### YAML Support

| Shortcut     | Action    |
| ------------ | --------- |
| `<leader>yv` | YAML lint |

## 📝 TODO Comments

| Shortcut     | Action         |
| ------------ | -------------- |
| `<leader>td` | Todo Telescope |
| `<leader>tq` | Todo QuickFix  |
| `<leader>tl` | Todo LocList   |
| `]t`         | Next todo      |
| `[t`         | Previous todo  |

## 📄 File Comparison

| Shortcut     | Action                |
| ------------ | --------------------- |
| `<leader>vd` | Vertical diff split   |
| `<leader>vD` | Horizontal diff split |
| `<leader>vf` | Turn off diff mode    |

## 📋 File Path Utilities

| Shortcut     | Action             |
| ------------ | ------------------ |
| `<leader>cp` | Copy full path     |
| `<leader>cf` | Copy filename      |
| `<leader>cr` | Copy relative path |

## 📖 Markdown Preview

| Shortcut     | Action                 |
| ------------ | ---------------------- |
| `<leader>mp` | Glow preview           |
| `<leader>mg` | Toggle glow            |
| `<leader>mr` | Toggle render-markdown |
| `<leader>mt` | Glow in terminal       |

## 🔧 LSP & Mason Management

| Shortcut     | Action       |
| ------------ | ------------ |
| `<leader>lm` | Open Mason   |
| `<leader>li` | LSP Info     |
| `<leader>lr` | LSP Restart  |
| `<leader>ll` | Mason Log    |
| `<leader>lu` | Mason Update |

## 🎨 Dashboard & Interface

| Shortcut    | Action         |
| ----------- | -------------- |
| `<leader>d` | Open dashboard |

## 💡 Configuration Files

- `init.lua` - Main configuration entry point
- `lua/mappings.lua` - All keybindings
- `lua/options.lua` - Vim options
- `lua/plugins/init.lua` - Plugin specifications
- `lua/configs/` - Plugin-specific configurations

## 🔌 LSP Servers

Install via Mason (`:Mason`):

```vim
:MasonInstall lua_ls        # Lua
:MasonInstall pyright       # Python
:MasonInstall gopls         # Go
:MasonInstall yamlls        # YAML
:MasonInstall bashls        # Bash
```

## Tips

- Use `<C-p>` and `<C-f>` for fast navigation
- Master buffer switching with `<S-l>` and `<S-h>`
- Use `<leader>w3` for 3-column layout
- Centered navigation (`n`, `N`, `*`, `#`) keeps context visible
- LSP features work automatically when language servers are installed
