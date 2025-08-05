# 🚀 Ultimate Dev Neovim Configuration

A blazing-fast Neovim setup optimized for Dev workflows, large monorepos, and multi-file navigation with Kubernetes, Helm, Terraform, and Go support.

Built on NvChad for performance and aesthetics, enhanced with professional Dev tooling.

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
| `<leader>pf` | Project files (git-aware) | Search in git repository |
| `<leader>pg` | Git tracked files only | Focus on version-controlled files |
| `<leader>pr` | Recent project files | Access recently opened files |

### File Type Searches
| Shortcut | Action | Perfect For |
|----------|--------|-------------|
| `<leader>fey` | Find YAML files | Kubernetes manifests, Helm charts |
| `<leader>fet` | Find Terraform files | Infrastructure as code |
| `<leader>feg` | Find Go files | Go microservices |
| `<leader>fej` | Find JSON files | Config files, API responses |
| `<leader>fep` | Find Python files | Scripts and automation |

### Advanced Search
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<C-f>` | Live grep | Search content across all files |
| `<leader>fG` | Live grep with args | Advanced regex search |
| `<leader>ft` | Find TODOs | Locate TODO/FIXME/HACK comments |
| `<leader>ds` | Grep in directory | Search within specific directory |

## 🪟 Multi-File Management

### Window Splitting
| Shortcut | Action | Layout |
|----------|--------|--------|
| `<leader>sv` | Vertical split | Side-by-side editing |
| `<leader>sh` | Horizontal split | Top-bottom editing |
| `<leader>sfv` | Find file in vertical split | Open file in new column |
| `<leader>sfh` | Find file in horizontal split | Open file below/above |

### Preset Layouts
| Shortcut | Action | Best For |
|----------|--------|----------|
| `<leader>w2` | 2-column layout | Code + docs |
| `<leader>w3` | 3-column layout | Code + tests + config |
| `<leader>w4` | 4-window grid | Full project overview |
| `<leader>wt` | Terminal split | Development with CLI |

### Window Navigation
```bash
<C-h>  # Move to left window
<C-j>  # Move to bottom window
<C-k>  # Move to top window
<C-l>  # Move to right window

# Resize windows
<C-Up/Down>    # Adjust height
<C-Left/Right> # Adjust width
```

### Buffer Management
```bash
<Shift-l>    # Next buffer
<Shift-h>    # Previous buffer
<leader>x    # Close buffer
<leader>bl   # List all buffers
```

## 🗂️ Directory Navigation

### Quick Directory Access
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>dd` | Navigate to directory | Interactive directory selection |
| `<leader>dc` | Files in current dir | Browse current working directory |
| `<leader>dp` | Files in parent dir | Browse parent of current file |
| `<leader>dr` | Files in git root | Jump to repository root |
| `-` | Browse parent directory | Quick parent navigation |
| `_` | Browse current directory | Quick current dir navigation |

### Directory Bookmarks
```bash
<leader>bh  # Jump to Helm3 project
<leader>bc  # Jump to config directory
<leader>bn  # Jump to Neovim config
```

### Change Working Directory
```bash
<leader>cd  # Change to current file's directory
<leader>cD  # Change to parent directory
<leader>ch  # Change to home directory
<leader>cw  # Show current working directory
```

## 🚢 Kubernetes Workflows

### File Operations
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>ka` | `kubectl apply -f %` | Apply current YAML file |
| `<leader>kd` | `kubectl describe -f %` | Describe resources in file |
| `<leader>kg` | `kubectl get -f %` | Get resources from file |
| `<leader>kv` | `kubectl validate -f %` | Validate YAML syntax |
| `<leader>kD` | `kubectl delete -f %` | Delete resources (careful!) |

### Navigation & Search
```bash
<leader>ky  # Find all Kubernetes YAML files
<leader>kf  # Grep in Kubernetes YAML files
<leader>ks  # Kubectl status overview
```

### Smart Features
- **Auto-detection** of K8s files in `/k8s/`, `/kubernetes/`, `/manifests/`
- **Schema validation** for Kubernetes v1.28.0 resources
- **Intelligent completion** for K8s API objects and fields
- **Hover documentation** for Kubernetes resources

## 🏗️ Terraform Workflows

```bash
<leader>ti  # terraform init
<leader>tp  # terraform plan
<leader>ta  # terraform apply
<leader>tv  # terraform validate
```

## 🐹 Go Development

```bash
<leader>gr  # Go run
<leader>gt  # Go test
<leader>gb  # Go build
<leader>gi  # Go install dependencies
<leader>gf  # Go format
```

## 🐳 Docker Workflows

```bash
<leader>db  # Docker build
<leader>dr  # Docker run
```

## 📝 Common Workflows

### 1. **Kubernetes Manifest Editing**
```bash
1. <leader>ky           # Find Kubernetes YAML files
2. Select manifest      # Open with LSP validation
3. <leader>ka           # Apply changes
4. <leader>ks           # Check status
```

### 2. **Multi-Service Development**
```bash
1. <leader>w3           # Create 3-column layout
2. <leader>sfv          # Open service A in column 1
3. <C-l> → <leader>sfv  # Open service B in column 2
4. <C-l> → <leader>sfv  # Open service C in column 3
5. <C-h/j/k/l>         # Navigate between services
```

### 3. **Infrastructure as Code**
```bash
1. <leader>fet          # Find Terraform files
2. Edit configuration   # With LSP support
3. <leader>tv           # Validate syntax
4. <leader>tp           # Plan changes
5. <leader>ta           # Apply changes
```

### 4. **Code Review Workflow**
```bash
1. <leader>pf           # Find file to review
2. <leader>vd oldfile   # Open diff comparison
3. Navigate changes     # Review side-by-side
4. <leader>vf           # Exit diff mode
```

### 5. **Debugging Session**
```bash
1. <leader>w4           # 4-window grid
2. Top-left: main code  # Primary focus
3. Top-right: tests     # Verification
4. Bottom-left: logs    # Error investigation
5. Bottom-right: terminal # Commands & debugging
```

### 6. **Large Monorepo Navigation**
```bash
1. <leader>fms          # Find in services/
2. <leader>fmp          # Find in packages/
3. <leader>fma          # Find in apps/
4. <leader>dr           # Jump to git root when lost
```

### 7. **Configuration Management**
```bash
1. <leader>fey          # Find YAML configs
2. <leader>fej          # Find JSON configs
3. Edit with validation # LSP provides schema validation
4. <leader>yv           # YAML lint validation
```

## 🎯 Harpoon - Quick File Switching

Perfect for frequently accessed files:

```bash
<leader>ha  # Add current file to harpoon
<leader>hh  # Show harpoon menu
<leader>h1  # Jump to file 1 (instant)
<leader>h2  # Jump to file 2 (instant)
<leader>h3  # Jump to file 3 (instant)
<leader>h4  # Jump to file 4 (instant)
```

**Harpoon Workflow:**
1. Open main files you work with frequently
2. `<leader>ha` on each to add to harpoon
3. Use `<leader>h1-4` for instant switching
4. Perfect for: main.go, config.yaml, Dockerfile, README.md

## 🔧 LSP Features

### Code Navigation
```bash
gd          # Go to definition
gr          # Show references
gi          # Go to implementation
K           # Hover documentation
<leader>rn  # Rename symbol
<leader>ca  # Code actions
```

### Diagnostics
```bash
]d          # Next diagnostic
[d          # Previous diagnostic
<leader>d   # Show diagnostic float
```

## 🎨 Git Integration

```bash
<leader>gf  # Git files
<leader>gs  # Git status
<leader>gl  # Git log
<leader>gb  # Git branches
<leader>gd  # Git diff view
```

## 🛠️ Installation & Setup

### LSP Servers (Install as needed)
```bash
:MasonInstall yamlls        # YAML/Kubernetes
:MasonInstall gopls         # Go
:MasonInstall pyright       # Python
:MasonInstall terraformls   # Terraform
:MasonInstall bashls        # Bash
:MasonInstall lua_ls        # Lua
```

### Dependencies
- **fd** - Fast file finding
- **ripgrep** - Fast text search
- **kubectl** - Kubernetes management
- **terraform** - Infrastructure as code
- **docker** - Container management

## 🚀 Performance Tips

1. **Use FZF for huge repos** - `<C-p>`, `<leader>Ff` are faster than Telescope
2. **Use Harpoon for frequent files** - Instant switching without search
3. **Use git-tracked files** - `<leader>pg` is much faster than full filesystem search
4. **Use extension-specific searches** - `<leader>fey` instead of general search
5. **Use directory bookmarks** - `<leader>bh` for instant project switching

## 📚 File Tree (Neo-tree)

```bash
<leader>e   # Toggle file tree
<leader>E   # Focus file tree
<leader>ef  # Reveal current file in tree
<leader>er  # Neo-tree as file manager
```

**Neo-tree Navigation:**
- `<space>` - Toggle folder
- `<enter>` - Open file
- `a` - Add file/folder
- `d` - Delete file/folder
- `r` - Rename file/folder
- `H` - Toggle hidden files

## 🎯 Pro Tips

### Speed Optimization
- Keep frequently used files in Harpoon (`<leader>h1-4`)
- Use directory bookmarks for common paths
- Master `<C-p>` and `<C-f>` for everything
- Use `<leader>pr` for recently opened files

### Multi-File Mastery
- `<leader>w3` + `<leader>sfv` for perfect 3-column setup
- `<Shift-l/h>` for quick buffer switching
- Use tabs for different contexts/features
- `<leader>vd` for file comparisons

### Dev Efficiency
- `<leader>ky` → `<leader>ka` → `<leader>ks` (K8s workflow)
- `<leader>fet` → `<leader>tv` → `<leader>tp` (Terraform workflow)
- Use `<leader>ds` for directory-specific searches
- Master `<leader>dd` for directory navigation

---

## 🙏 Credits

**Built on:**
- [NvChad](https://github.com/NvChad/NvChad) - Beautiful and fast Neovim config
- [LazyVim Starter](https://github.com/LazyVim/starter) - Inspiration for plugin management

**🎉 Happy coding with your supercharged Neovim setup!**

> This configuration is optimized for Dev workflows, large monorepos, and lightning-fast navigation. Every shortcut is designed for maximum efficiency and minimum keystrokes.
