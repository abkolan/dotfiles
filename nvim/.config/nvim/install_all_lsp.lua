-- Quick script to install all LSP servers
-- Run this with :luafile install_all_lsp.lua

local servers = {
  "yaml-language-server",
  "bash-language-server", 
  "terraform-ls",
  "pyright",
  "gopls",
  "docker-langserver",
  "helm-ls",
  "json-lsp",
  "html-lsp",
  "css-lsp",
  "lua-language-server",
}

local tools = {
  "prettier",
  "black", 
  "isort",
  "gofumpt",
  "shfmt",
  "yamllint",
  "shellcheck",
  "tflint",
}

-- Install LSP servers
for _, server in ipairs(servers) do
  vim.cmd("MasonInstall " .. server)
end

-- Install tools
for _, tool in ipairs(tools) do
  vim.cmd("MasonInstall " .. tool)
end

print("Installing all LSP servers and tools...")
print("Check :Mason to see progress")