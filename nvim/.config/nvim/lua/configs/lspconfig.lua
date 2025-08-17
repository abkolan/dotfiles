require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- DevOps and Infrastructure LSP servers
local servers = {
  "html",
  "cssls", 
  "pyright",           -- Python
  "gopls",             -- Go
  "terraformls",       -- Terraform
  -- "yamlls" is configured separately in configs/yamlls.lua
  "bashls",            -- Bash
  "dockerls",          -- Docker
  "helm_ls",           -- Helm
  "jsonls",            -- JSON
  "sqls",              -- SQL
  "docker_compose_language_service", -- Docker Compose
}

-- Enable servers with default config (only if installed)
for _, lsp in ipairs(servers) do
  local ok, _ = pcall(function()
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end)
  if not ok then
    vim.notify("LSP server " .. lsp .. " not found. Install it with :MasonInstall " .. lsp, vim.log.levels.WARN)
  end
end

-- Python specific configuration (only if installed)
pcall(function()
  lspconfig.pyright.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "basic"
        }
      }
    }
  }
end)

-- Go specific configuration (only if installed)
pcall(function()
  lspconfig.gopls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
}
end)

-- Terraform configuration (only if installed)
pcall(function()
  lspconfig.terraformls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "terraform", "hcl" },
}
end)

-- JSON configuration (only if installed)
pcall(function()
  lspconfig.jsonls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    json = {
      schemas = (function()
        local ok, schemastore = pcall(require, 'schemastore')
        if ok then
          return schemastore.json.schemas()
        else
          return {}
        end
      end)(),
      validate = { enable = true },
    },
  },
}
end)

-- SQL LSP configuration (only if installed)
pcall(function()
  lspconfig.sqls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    sqls = {
      connections = {
        {
          driver = "mysql",
          -- Use environment variable: export DB_MYSQL_DSN="root:YOUR_PASSWORD@tcp(127.0.0.1:3306)/dbname"
          dataSourceName = vim.fn.getenv("DB_MYSQL_DSN") ~= vim.NIL and vim.fn.getenv("DB_MYSQL_DSN") or "",
        },
        {
          driver = "postgresql",
          -- Use environment variable: export DB_POSTGRES_DSN="host=127.0.0.1 port=5432 user=postgres password=YOUR_PASSWORD dbname=dbname sslmode=disable"
          dataSourceName = vim.fn.getenv("DB_POSTGRES_DSN") ~= vim.NIL and vim.fn.getenv("DB_POSTGRES_DSN") or "",
        },
      },
    },
  },
}
end)

-- Docker LSP configuration (only if installed)
pcall(function()
  lspconfig.dockerls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    },
  },
}
end)

-- Docker Compose LSP (only if installed)
pcall(function()
  lspconfig.docker_compose_language_service.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}
end)

-- YAML Language Server is configured separately
-- See configs/yamlls.lua for the configuration
require("configs.yamlls").setup()
