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
  "yamlls",            -- YAML
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

-- Python specific configuration
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

-- Go specific configuration
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


-- Terraform configuration
lspconfig.terraformls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "terraform", "hcl" },
}

-- JSON configuration
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

-- SQL LSP configuration
lspconfig.sqls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    sqls = {
      connections = {
        {
          driver = "mysql",
          dataSourceName = "root:password@tcp(127.0.0.1:3306)/dbname",
        },
        {
          driver = "postgresql",
          dataSourceName = "host=127.0.0.1 port=5432 user=postgres password=password dbname=dbname sslmode=disable",
        },
      },
    },
  },
}

-- Docker LSP configuration
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

-- Docker Compose LSP
lspconfig.docker_compose_language_service.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- Kubernetes LSP (using yamlls with enhanced Kubernetes schemas)
lspconfig.yamlls.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    
    -- Enhanced Kubernetes detection and schema assignment
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local basename = vim.fn.fnamemodify(filename, ":t")
    
    -- Auto-detect Kubernetes files and set appropriate schemas
    if string.match(filename, "k8s/") or 
       string.match(filename, "kubernetes/") or
       string.match(basename, "%.k8s%.ya?ml$") or
       string.match(basename, "^kustomization%.ya?ml$") then
      
      vim.b[bufnr].yaml_schema = "kubernetes"
      vim.notify("Kubernetes schema applied to " .. basename, vim.log.levels.INFO)
    end
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    yaml = {
      schemas = {
        -- Kubernetes schemas
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.0-standalone-strict/all.json"] = {
          "/*.k8s.yaml",
          "/*.k8s.yml", 
          "/k8s/**/*.yaml",
          "/k8s/**/*.yml",
          "/kubernetes/**/*.yaml", 
          "/kubernetes/**/*.yml",
          "/manifests/**/*.yaml",
          "/manifests/**/*.yml"
        },
        
        -- Kustomization
        ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
        
        -- GitHub workflows
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        
        -- Helm charts
        ["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
        
        -- Docker Compose
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
        
        -- Ansible
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] = "roles/tasks/*.{yml,yaml}",
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*play*.{yml,yaml}",
        ["https://json.schemastore.org/ansible-stable-2.9.json"] = "site.{yml,yaml}",
      },
      validate = true,
      completion = true,
      hover = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      customTags = {
        "!reference sequence",
        "!secret scalar",
        "!vault scalar",
      },
      format = {
        enable = true,
        singleQuote = false,
        bracketSpacing = true,
      },
    },
  },
}
