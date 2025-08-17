#!/bin/bash

# Install common LSP servers and tools for DevOps workflows
# This script helps you quickly set up your development environment

echo "Installing common LSP servers and development tools..."

# Install LSP servers
nvim --headless \
  -c 'lua require("mason").setup()' \
  -c 'lua require("mason.api.command").MasonInstall({"lua-language-server", "yaml-language-server", "bash-language-server", "json-lsp"})' \
  -c 'sleep 3' \
  -c 'lua require("mason.api.command").MasonInstall({"pyright", "gopls", "dockerfile-language-server", "terraform-ls"})' \
  -c 'sleep 3' \
  -c 'lua require("mason.api.command").MasonInstall({"stylua", "prettier", "black", "shfmt", "shellcheck", "yamllint"})' \
  -c 'sleep 10' \
  -c 'qall'

echo "LSP server installation completed!"
echo "You can check the status with ':Mason' command in Neovim"
echo ""
echo "Available LSP servers:"
echo "  - lua-language-server (Lua)"
echo "  - yaml-language-server (YAML/Kubernetes)"  
echo "  - bash-language-server (Bash/Shell)"
echo "  - json-lsp (JSON)"
echo "  - pyright (Python)"
echo "  - gopls (Go)"
echo "  - dockerfile-language-server (Docker)"
echo "  - terraform-ls (Terraform)"
echo ""
echo "Available formatters and linters:"
echo "  - stylua (Lua formatter)"
echo "  - prettier (Web/JSON formatter)"
echo "  - black (Python formatter)"
echo "  - shfmt (Shell formatter)"
echo "  - shellcheck (Shell linter)"
echo "  - yamllint (YAML linter)"