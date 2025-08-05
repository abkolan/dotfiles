# LSP Server Installation Guide

## Quick Fix for Current Error

1. **Restart Neovim** - Mason will automatically start installing servers
2. **Manual Install**: Open Neovim and run:
   ```vim
   :Mason
   ```
   Then search for and install these servers:
   - `bash-language-server`
   - `yaml-language-server` 
   - `terraform-ls`
   - `pyright`
   - `gopls`

## Automatic Installation (Recommended)

Your config is now set up to automatically install all required LSP servers. Here's what happens:

### When you restart Neovim:
1. Mason will automatically install all LSP servers listed in `ensure_installed`
2. You'll see installation progress in the bottom right
3. Once complete, all language servers will work automatically

### LSP Servers that will be installed:
- **Python**: `pyright`
- **Go**: `gopls` 
- **Terraform**: `terraformls`
- **YAML**: `yamlls`
- **Bash**: `bashls`
- **Docker**: `dockerls`
- **Helm**: `helm_ls`
- **JSON**: `jsonls`
- **HTML**: `html`
- **CSS**: `cssls`
- **TypeScript/JS**: `ts_ls`
- **Lua**: `lua_ls`
- **Markdown**: `marksman`

### Additional Tools that will be installed:
- **Formatters**: prettier, black, isort, gofumpt, shfmt, terraform-fmt
- **Linters**: eslint_d, pylint, flake8, golangci-lint, yamllint, shellcheck, tflint
- **Debuggers**: debugpy (Python), delve (Go)

## Manual Commands (if needed)

If automatic installation doesn't work, you can manually install:

```vim
" Install all LSP servers
:MasonInstall bash-language-server yaml-language-server terraform-ls pyright gopls dockerls helm-ls jsonls

" Install formatters and linters
:MasonInstall prettier black isort gofumpt shfmt terraform-fmt eslint_d pylint flake8 golangci-lint yamllint shellcheck tflint

" Install debuggers
:MasonInstall debugpy delve
```

## Check Installation Status

```vim
:Mason                    " Open Mason UI
:MasonLog                " View installation logs
:checkhealth mason       " Check Mason health
:LspInfo                 " Check LSP server status
```

## Troubleshooting

### If LSP servers still don't work:
1. Check if they're in PATH: `:echo $PATH`
2. Check Mason install directory: `:echo stdpath('data') . '/mason/bin'`
3. Manually add to PATH in your shell config:
   ```bash
   export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
   ```

### Common Issues:
- **Permission errors**: Make sure `~/.local/share/nvim/mason/bin` is writable
- **Network issues**: Check internet connection for downloads
- **Node.js required**: Some servers need Node.js installed
- **Python required**: Some tools need Python 3.6+

## Verify Everything Works

After installation, test each language:
1. Open a `.py` file - should see Python LSP working
2. Open a `.go` file - should see Go LSP working  
3. Open a `.tf` file - should see Terraform LSP working
4. Open a `.yaml` file - should see YAML LSP working
5. Open a `.sh` file - should see Bash LSP working

You should see:
- ✅ Syntax highlighting
- ✅ Auto-completion
- ✅ Error diagnostics
- ✅ Go-to-definition (gd)
- ✅ Hover documentation (K)