local mason = require("mason")

-- Mason setup with automatic installation for dotfiles portability
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    },
    border = "rounded",
    width = 0.8,
    height = 0.9,
  },
  install_root_dir = vim.fn.stdpath("data") .. "/mason",
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
})

-- Mason is now setup without mason-lspconfig to avoid initialization errors
-- LSP servers can be installed manually with :MasonInstall <server_name>
-- Common LSP servers for DevOps:
-- :MasonInstall lua_ls yamlls bashls jsonls sqls dockerls pyright gopls terraformls