-- Simplified YAML Language Server configuration with Kubernetes support
local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  local nvlsp = require("nvchad.configs.lspconfig")
  
  -- YAML Language Server with Kubernetes schemas
  lspconfig.yamlls.setup({
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      -- Enable completion explicitly
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
    on_init = nvlsp.on_init,
    capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
      textDocument = {
        completion = {
          completionItem = {
            documentationFormat = { "markdown", "plaintext" },
            snippetSupport = true,
            preselectSupport = true,
            insertReplaceSupport = true,
            labelDetailsSupport = true,
            deprecatedSupport = true,
            commitCharactersSupport = true,
            tagSupport = { valueSet = { 1 } },
            resolveSupport = {
              properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
              },
            },
          },
        },
      },
    }),
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          -- Enable schema store for better auto-detection
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = {
          -- Kubernetes - this will match ANY yaml file that has apiVersion and kind
          ["kubernetes"] = "*.yaml",
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone-strict/all.json"] = "*.yaml",
        },
        completion = true,
        hover = true,
      },
    },
  })
end

return M