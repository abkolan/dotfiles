# 🚀 Streamlined Neovim Configuration

A clean, fast Neovim setup based on NvChad, optimized for generic text editing and navigation. Focused on core functionality without language-specific bloat.

Built on NvChad for performance and aesthetics, enhanced with essential development tools.

## ⚡ Quick Start

### Essential Shortcuts (Muscle Memory)
```bash
<C-p>              # Quick file finder (FZF)
<C-f>              # Live grep search
<leader><leader>   # Quick buffer switch
<leader>e          # Toggle file tree
```

## 🗂️ File Navigation & Search

### Fast File Finding
| Shortcut | Action | Use Case |
|----------|--------|----------|
| `<C-p>` | Quick file finder | Find any file instantly |
| `<leader>pf` | Project files (smart) | Git-aware project search |
| `<leader>pg` | Git tracked files | Focus on version-controlled files |
| `<leader>pr` | Recent project files | Access recently opened files |

### Telescope Search (Comprehensive)
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>ff` | Smart find files | Telescope smart file search |
| `<leader>fg` | Live grep | Search content across all files |
| `<leader>fb` | Find buffers | Search open buffers |
| `<leader>fh` | Help tags | Search vim help |
| `<leader>fo` | Old files | Recently opened files |
| `<leader>fc` | Commands | Search vim commands |
| `<leader>fk` | Keymaps | Search keybindings |

### File Type Searches
| Shortcut | Action | Perfect For |
|----------|--------|-------------|
| `<leader>fey` | Find YAML files | Configuration files |
| `<leader>fej` | Find JSON files | Config files, API responses |
| `<leader>fep` | Find Python files | Scripts and automation |
| `<leader>feg` | Find Go files | Go development |
| `<leader>fes` | Find shell scripts | Bash/shell scripts |

### FZF-Lua (Fast Alternative)
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>Ff` | FZF files | Fast file search |
| `<leader>Fg` | FZF live grep | Fast content search |
| `<leader>Fb` | FZF buffers | Fast buffer search |
| `<leader>Fo` | FZF old files | Fast recent files |
| `<leader>Fh` | FZF help | Fast help search |
| `<leader>Fc` | FZF commands | Fast command search |
| `<leader>Fk` | FZF keymaps | Fast keymap search |

### Advanced Search
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>fG` | Live grep with args | Advanced regex search |
| `<leader>ft` | Find TODOs | Locate TODO/FIXME comments |
| `<leader>ds` | Grep in directory | Search within specific directory |
| `<leader>dg` | Grep in git root | Search from repository root |

## 🪟 Multi-File & Window Management

### Window Splitting
| Shortcut | Action | Layout |
|----------|--------|--------|
| `<leader>sv` | Vertical split | Side-by-side editing |
| `<leader>sh` | Horizontal split | Top-bottom editing |
| `<leader>sfv` | Find file in vertical split | Open file in new column |
| `<leader>sfh` | Find file in horizontal split | Open file below/above |
| `<leader>sft` | Find file in new tab | Open file in new tab |

### Window Management
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>se` | Equalize windows | Make all windows same size |
| `<leader>sc` | Close window | Close current window |
| `<leader>so` | Only window | Close all other windows |

### Preset Layouts
| Shortcut | Action | Best For |
|----------|--------|----------|
| `<leader>w2` | 2-column layout | Code + docs |
| `<leader>w3` | 3-column layout | Code + tests + config |
| `<leader>w4` | 4-window grid | Full project overview |
| `<leader>wt` | Terminal split (horizontal) | Development with CLI |
| `<leader>wT` | Terminal split (vertical) | Side terminal |

### Window Navigation
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<C-h>` | Move left | Navigate to left window |
| `<C-j>` | Move down | Navigate to bottom window |
| `<C-k>` | Move up | Navigate to top window |
| `<C-l>` | Move right | Navigate to right window |

### Window Resizing
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<C-Up>` | Increase height | Make window taller |
| `<C-Down>` | Decrease height | Make window shorter |
| `<C-Left>` | Decrease width | Make window narrower |
| `<C-Right>` | Increase width | Make window wider |

## 📁 Directory Navigation

### Quick Directory Access
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>dd` | Navigate to directory | fzf directory picker + set Neo-tree root |
| `<leader>dcd` | Change directory | Pure directory change (like fcd) |
| `<leader>dc` | Files in current dir | Browse current working directory |
| `<leader>dp` | Files in parent dir | Browse parent of current file |
| `<leader>dh` | Files in home dir | Browse home directory |
| `<leader>dr` | Files in git root | Jump to repository root |
| `-` | Browse parent directory | Quick parent navigation |
| `_` | Browse current directory | Quick current dir navigation |

### Quick Directory Jumps
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>d.` | Config directory | Jump to .config |
| `<leader>dt` | Temp directory | Jump to /tmp |
| `<leader>dl` | Log directory | Jump to /var/log |

### Directory Bookmarks
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>bc` | Config directory | Jump to ~/.config |
| `<leader>bn` | Neovim config | Jump to ~/.config/nvim |

### Change Working Directory
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>cd` | Change to file directory | Set CWD to current file's dir |
| `<leader>cD` | Change to parent | Set CWD to parent directory |
| `<leader>ch` | Change to home | Set CWD to home directory |
| `<leader>cw` | Show working directory | Display current working directory |

## 📋 Buffer & Tab Management

### Buffer Operations
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>x` | Delete buffer | Safe buffer close |
| `<leader>X` | Force delete buffer | Force close (lose changes) |
| `]b` | Next buffer | Navigate to next buffer |
| `[b` | Previous buffer | Navigate to previous buffer |
| `<S-l>` | Next buffer (quick) | Quick next buffer |
| `<S-h>` | Previous buffer (quick) | Quick previous buffer |
| `<leader>bl` | List buffers | Show all open buffers |

### Tab Management
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>tn` | New tab | Create new tab |
| `<leader>tc` | Close tab | Close current tab |
| `<leader>to` | Only tab | Close all other tabs |
| `<leader>tp` | Previous tab | Go to previous tab |
| `<leader>tN` | Next tab | Go to next tab |
| `<leader>tm` | Move tab | Move current tab |

### Tab Navigation (Numbers)
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>1` | Go to tab 1 | Jump to first tab |
| `<leader>2` | Go to tab 2 | Jump to second tab |
| `<leader>3` | Go to tab 3 | Jump to third tab |
| `<leader>4` | Go to tab 4 | Jump to fourth tab |
| `<leader>5` | Go to tab 5 | Jump to fifth tab |

## 🎯 LSP & Code Features

### LSP Navigation
| Shortcut | Action | Description |
|----------|--------|-------------|
| `gd` | Go to definition | Jump to symbol definition |
| `gD` | Go to declaration | Jump to symbol declaration |
| `gi` | Go to implementation | Jump to implementation |
| `gr` | Show references | Show all references |
| `K` | Hover documentation | Show documentation |
| `<C-k>` | Signature help | Show function signature |

### LSP Actions
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>rn` | Rename symbol | Rename across project |
| `<leader>ca` | Code actions | Show available code actions |
| `<leader>f` | Format document | Format current file |

### LSP Telescope Integration
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>fs` | Document symbols | Symbols in current file |
| `<leader>fS` | Workspace symbols | Symbols in workspace |
| `<leader>fr` | LSP references | Find references via Telescope |
| `<leader>fi` | LSP implementations | Find implementations |
| `<leader>fd` | LSP definitions | Find definitions |
| `<leader>fD` | Diagnostics | Show all diagnostics |

### LSP FZF-Lua Integration
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>Fs` | FZF document symbols | Fast symbol search |
| `<leader>FS` | FZF workspace symbols | Fast workspace symbols |
| `<leader>Fr` | FZF references | Fast reference search |
| `<leader>Fi` | FZF implementations | Fast implementation search |
| `<leader>Fd` | FZF definitions | Fast definition search |
| `<leader>FD` | FZF diagnostics | Fast diagnostic search |

### File Outline
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>o` | File outline (symbols) | FZF-based outline |
| `<leader>O` | File outline (detailed) | Telescope-based outline |
| `<leader>wo` | Workspace symbols | Search workspace symbols |

## 🩺 Diagnostics & Navigation

### Diagnostic Navigation
| Shortcut | Action | Description |
|----------|--------|-------------|
| `[d` | Previous diagnostic | Go to previous error/warning |
| `]d` | Next diagnostic | Go to next error/warning |
| `<leader>D` | Show diagnostic | Show diagnostic details |

### Search Navigation (Centered)
| Shortcut | Action | Description |
|----------|--------|-------------|
| `n` | Next search (centered) | Next search result, centered |
| `N` | Previous search (centered) | Previous search result, centered |
| `*` | Search word forward (centered) | Search current word forward |
| `#` | Search word backward (centered) | Search current word backward |

### Jump Navigation (Centered)
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<C-o>` | Jump back (centered) | Previous location, centered |
| `<C-i>` | Jump forward (centered) | Next location, centered |

### Reference Navigation
| Shortcut | Action | Description |
|----------|--------|-------------|
| `]r` | Next reference | Next in quickfix list |
| `[r` | Previous reference | Previous in quickfix list |
| `]R` | Last reference | Last in quickfix list |
| `[R` | First reference | First in quickfix list |

### Enhanced Symbol Search
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>*` | Grep word under cursor | Search current word in project |
| `<leader>#` | Grep WORD under cursor | Search current WORD in project |

## 📋 Quickfix & List Management

### Quickfix Operations
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>qo` | Open quickfix | Open quickfix list |
| `<leader>qc` | Close quickfix | Close quickfix list |
| `<leader>qq` | Close quickfix (quick) | Quick close quickfix |
| `<C-q>` | Close quickfix (super quick) | Super quick close |

## 🌳 File Explorer (Neo-tree)

### Neo-tree Operations
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>e` | Toggle Neo-tree | Show/hide file tree |
| `<leader>E` | Focus Neo-tree | Focus on file tree |
| `<leader>ef` | Reveal current file | Show current file in tree |
| `<leader>ec` | Close Neo-tree | Close file tree |
| `<leader>er` | Neo-tree file manager | Open as file manager |

### Neo-tree Specialized Views
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>ge` | Neo-tree git status | Git status in tree |
| `<leader>be` | Neo-tree buffers | Buffer list in tree |

## 🎨 Git Integration

### Git File Operations
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>gf` | Git files | Search git-tracked files |
| `<leader>gs` | Git status | Show git status |
| `<leader>gl` | Git log | Show commit history |
| `<leader>gL` | Git buffer commits | Commits for current file |
| `<leader>gb` | Git branches | Show/switch branches |

### Diffview Integration
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>gd` | Git diff view | Open diff view |
| `<leader>gh` | Git file history | Show file history |
| `<leader>gc` | Close diff view | Close diff view |

## 🔧 Language Support

### Go Development
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>gr` | Go run | Run current Go file |
| `<leader>gt` | Go test | Run Go tests |
| `<leader>gb` | Go build | Build Go project |
| `<leader>gi` | Go install deps | Install Go dependencies |
| `<leader>gf` | Go format | Format Go code |

### Python Development
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>pr` | Run Python file | Execute current Python file |
| `<leader>pt` | Run pytest | Run Python tests |

### YAML Support
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>yv` | YAML lint | Validate YAML syntax |

## 📝 TODO Comments

### TODO Navigation
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>td` | Todo Telescope | Search TODOs with Telescope |
| `<leader>tq` | Todo QuickFix | TODOs in quickfix list |
| `<leader>tl` | Todo LocList | TODOs in location list |
| `]t` | Next todo | Jump to next TODO |
| `[t` | Previous todo | Jump to previous TODO |

## 📄 File Comparison

### Diff Operations
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>vd` | Vertical diff split | Compare files vertically |
| `<leader>vD` | Horizontal diff split | Compare files horizontally |
| `<leader>vf` | Turn off diff mode | Exit diff mode |

## 📋 File Path Utilities

### Copy File Paths
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>cp` | Copy full path | Copy absolute file path |
| `<leader>cf` | Copy filename | Copy filename only |
| `<leader>cr` | Copy relative path | Copy relative file path |

## 📖 Markdown Preview

### Markdown Operations
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>mp` | Glow preview | Markdown preview with Glow |
| `<leader>mg` | Toggle glow | Toggle Glow preview |
| `<leader>mr` | Render markdown | Toggle render-markdown |
| `<leader>mt` | Glow in terminal | Glow in terminal buffer |

## 🔧 LSP & Mason Management

### LSP Management
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>lm` | Open Mason | Package manager for LSP |
| `<leader>li` | LSP Info | Show LSP information |
| `<leader>lr` | LSP Restart | Restart language servers |
| `<leader>ll` | Mason Log | View Mason logs |
| `<leader>lu` | Mason Update | Update Mason packages |

## 🎨 Dashboard & Interface

### NvChad Dashboard
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>d` | Open dashboard | Show NvChad start screen |

## 🚀 Core Vim Shortcuts

### Basic Operations
| Shortcut | Action | Description |
|----------|--------|-------------|
| `;` | Command mode | Enter command mode |
| `jk` | Escape (Insert mode) | Exit insert mode |

## 📚 Installation & Setup

### Quick Install
```bash
# Using GNU Stow (recommended)
cd ~/dotfiles
stow nvim

# Launch Neovim
nvim
```

### Dependencies
- **fd** - Fast file finding
- **ripgrep** - Fast text search  
- **glow** - Markdown preview
- **Node.js** - LSP servers
- **Python 3** - Python LSP

### LSP Servers (Install via Mason)
```vim
:MasonInstall lua_ls        # Lua
:MasonInstall pyright       # Python  
:MasonInstall gopls         # Go
:MasonInstall yamlls        # YAML
:MasonInstall bashls        # Bash
```

## 🎯 Pro Tips

### Speed Optimization
- Use `<C-p>` and `<C-f>` for everything
- Use `<leader>pr` for recently opened files
- Use directory bookmarks (`<leader>bc`, `<leader>bn`)
- Master buffer switching (`<S-l>`, `<S-h>`)

### Multi-File Mastery
- `<leader>w3` + `<leader>sfv` for perfect 3-column setup
- Use tabs for different contexts/features
- `<leader>vd` for file comparisons
- `<leader><leader>` for quick buffer switching

### Navigation Efficiency
- Use centered navigation (`n`, `N`, `*`, `#`)
- Master quickfix navigation (`]r`, `[r`)
- Use LSP navigation (`gd`, `gr`, `gi`)
- Use enhanced symbol search (`<leader>*`, `<leader>#`)

---

## 🙏 Credits

**Built on:**
- [NvChad](https://github.com/NvChad/NvChad) - Beautiful and fast Neovim config

**🎉 Happy coding with your streamlined Neovim setup!**

> This configuration focuses on core text editing and navigation features without language-specific bloat. Every shortcut is designed for maximum efficiency and minimal keystrokes.