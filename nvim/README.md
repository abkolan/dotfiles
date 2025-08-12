# Neovim Configuration

A modern Neovim setup based on NvChad v2.5 with extensive customizations for development, including LSP support, debugging, AI integration, and DevOps tooling.

## Prerequisites

### Required Software

1. **Neovim** (>= 0.9.4)

   ```bash
   # macOS
   brew install neovim
   ```

2. **Git** (for plugin management)

   ```bash
   # macOS
   brew install git
   ```

3. **GNU Stow** (for dotfiles management)

   ```bash
   # macOS
   brew install stow
   ```

4. **Node.js & npm** (for LSP servers and tools)

   ```bash
   # Install via nvm (recommended)
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   source ~/.bashrc  # or ~/.zshrc
   nvm install node
   nvm use node

   # Or via package manager
   brew install node  # macOS
   ```

5. **Python 3** (for Python LSP and tools)
   ```bash
   # macOS
   brew install python3
   ```

### Optional but Recommended

- **ripgrep** (for faster searching)

  ```bash
  brew install ripgrep  # macOS
  ```

- **fd** (find alternative)

  ```bash
  brew install fd  # macOS
  ```

- **fzf** (fuzzy finder)

  ```bash
  brew install fzf  # macOS
  ```

- **lazygit** (git UI)

  ```bash
  brew install lazygit  # macOS
  ```

- **Claude CLI** (AI assistance)
  ```bash
  npm install -g @anthropic-ai/claude-cli
  ```

## Installation

### Method 1: Using GNU Stow (Recommended)

1. Clone this repository to your dotfiles directory:

   ```bash
   git clone <your-repo> ~/dotfiles
   cd ~/dotfiles
   ```

2. Back up your existing Neovim configuration:

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   mv ~/.cache/nvim ~/.cache/nvim.backup
   ```

3. Use stow to create symlinks:

   ```bash
   stow nvim
   ```

4. Install NvChad:
   ```bash
   # NvChad will be automatically bootstrapped on first launch
   nvim
   ```

### Method 2: Manual Installation

1. Back up existing configuration:

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Copy this configuration:

   ```bash
   cp -r ~/dotfiles/nvim/.config/nvim ~/.config/
   ```

3. Launch Neovim:
   ```bash
   nvim
   ```

## Post-Installation Setup

### 1. Install Plugins

Launch Neovim and wait for lazy.nvim to install all plugins:

```bash
nvim
# Plugins will auto-install on first launch
# Or manually with :Lazy sync
```

### 2. Install LSP Servers

Open Neovim and run:

```vim
:MasonInstallAll
```

Or install specific language servers:

```vim
:Mason
# Press 'i' on any server to install
```

Common LSP servers:

- `typescript-language-server` (TypeScript/JavaScript)
- `pyright` or `pylsp` (Python)
- `lua-language-server` (Lua)
- `gopls` (Go)
- `rust-analyzer` (Rust)
- `yaml-language-server` (YAML)
- `docker-language-server` (Docker)
- `terraform-ls` (Terraform)

### 3. Install Treesitter Parsers

```vim
:TSInstall all
# Or install specific parsers
:TSInstall python javascript typescript lua go rust
```

### 4. Configure AI Tools (Optional)

If using Claude integration:

```bash
# Install Claude CLI
npm install -g @anthropic-ai/claude-cli

# Configure API key
claude login
```

## Features

### Core Features

- **NvChad Base**: Beautiful UI with multiple themes
- **LSP Support**: Full Language Server Protocol integration
- **Autocompletion**: nvim-cmp with multiple sources
- **File Explorer**: Neo-tree with icons
- **Fuzzy Finding**: Telescope and FZF-lua integration
- **Git Integration**: Gitsigns, fugitive, and lazygit
- **Terminal**: Integrated terminal with toggleterm
- **Debugging**: DAP (Debug Adapter Protocol) support

### Custom Additions

- **AI Integration**: Claude Code support for AI assistance
- **DevOps Tools**: Kubernetes, Docker, Terraform support
- **Advanced Search**: Optimized for monorepos
- **Session Management**: Auto-session support
- **Enhanced Motions**: Flash.nvim for quick navigation
- **Markdown Preview**: Live markdown rendering

## Key Mappings

### Leader Key: `<Space>`

#### File Operations

- `<leader>ff` - Find files (smart)
- `<leader>fw` - Find word (grep)
- `<leader>fb` - Find buffers
- `<leader>fh` - Find help
- `<leader>fo` - Find old files (recent)

#### Code Actions

- `<leader>ca` - Code actions
- `<leader>cf` - Format code
- `<leader>rn` - Rename symbol
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover documentation

#### Git Operations

- `<leader>gg` - Open lazygit
- `<leader>gd` - Git diff
- `<leader>gb` - Git blame

#### AI Assistance

- `<leader>cc` - Open Claude Code
- `<leader>ct` - Claude in new tab

## Troubleshooting

### Common Issues

1. **Plugins not loading**

   ```vim
   :Lazy sync
   :Lazy update
   ```

2. **LSP not working**

   ```vim
   :LspInfo
   :Mason
   # Check if language server is installed
   ```

3. **Treesitter errors**

   ```vim
   :TSUpdate
   :TSInstall <language>
   ```

4. **Node.js path issues**

   - Ensure nvm is properly installed
   - The configuration now dynamically detects Node versions

5. **Performance issues**
   ```vim
   :checkhealth
   # Review any warnings or errors
   ```

### Health Check

Run a complete health check:

```vim
:checkhealth
```

### Reset Configuration

If you encounter issues, you can reset:

```bash
# Remove all Neovim data
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Reinstall
nvim
```

## Customization

### Adding Plugins

Edit `lua/plugins/init.lua`:

```lua
{
  "username/plugin-name",
  config = function()
    require("plugin-name").setup({})
  end,
}
```

### Modifying Keymaps

Edit `lua/mappings.lua`:

```lua
local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>YourCommand<cr>", { desc = "Description" })
```

### Changing Options

Edit `lua/options.lua` for Neovim settings.

## Updates

To update the configuration:

```bash
cd ~/dotfiles
git pull
# Restart Neovim
```

To update plugins:

```vim
:Lazy update
:MasonUpdate
:TSUpdate
```

## License

This configuration is based on [NvChad](https://nvchad.com/) and includes various community plugins. Please refer to individual plugin licenses.

## Support

For issues or questions:

1. Check `:checkhealth` output
2. Review plugin documentation
3. Check NvChad documentation: https://nvchad.com/docs/
4. Create an issue in the repository

---

**Note**: This configuration is optimized for development work and includes extensive tooling. You may want to disable unused features for better performance on lower-end systems.
