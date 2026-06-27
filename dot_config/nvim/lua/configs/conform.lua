local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    
    -- DevOps Languages
    python = { "black", "isort" },
    go = { "goimports", "gofmt" },
    terraform = { "terraform_fmt" },
    yaml = { "prettier" },
    json = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    markdown = { "prettier" },
    sh = { "shfmt" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
