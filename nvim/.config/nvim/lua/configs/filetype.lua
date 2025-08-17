-- DevOps file type detection
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
    helm = "helm",
  },
  filename = {
    ["Dockerfile"] = "dockerfile",
    ["Containerfile"] = "dockerfile",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["Chart.yaml"] = "yaml.helm",
    ["Chart.yml"] = "yaml.helm",
    ["values.yaml"] = "yaml.helm",
    ["values.yml"] = "yaml.helm",
    [".terraformrc"] = "hcl",
    ["terraform.rc"] = "hcl",
    ["Jenkinsfile"] = "groovy",
    [".gitlab-ci.yml"] = "yaml.gitlab",
    [".github/workflows/*"] = "yaml.github",
    ["kustomization.yaml"] = "yaml.kubernetes",
    ["kustomization.yml"] = "yaml.kubernetes",
  },
  pattern = {
    [".*%.tf%.j2"] = "terraform",
    [".*%.yaml%.j2"] = "yaml.ansible",
    [".*%.yml%.j2"] = "yaml.ansible",
    ["roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    ["roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    ["group_vars/.*%.ya?ml"] = "yaml.ansible",
    ["host_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*playbook.*%.ya?ml"] = "yaml.ansible",
    [".*inventory.*"] = "ansible_hosts",
    ["k8s/.*%.ya?ml"] = "yaml.kubernetes",
    ["kubernetes/.*%.ya?ml"] = "yaml.kubernetes",
    ["manifests/.*%.ya?ml"] = "yaml.kubernetes",
    ["charts/.*/templates/.*%.ya?ml"] = "yaml.helm",
  }
})

-- Auto commands for DevOps files
vim.api.nvim_create_augroup("DevOpsFileTypes", { clear = true })

-- Terraform
vim.api.nvim_create_autocmd("FileType", {
  group = "DevOpsFileTypes",
  pattern = { "terraform", "hcl" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = "# %s"
  end,
})

-- YAML/Helm/Kubernetes
vim.api.nvim_create_autocmd("FileType", {
  group = "DevOpsFileTypes", 
  pattern = { "yaml", "yaml.helm", "yaml.kubernetes", "yaml.docker-compose", "yaml.ansible" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.foldmethod = "indent"
  end,
})

-- Go
vim.api.nvim_create_autocmd("FileType", {
  group = "DevOpsFileTypes",
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})

-- Python
vim.api.nvim_create_autocmd("FileType", {
  group = "DevOpsFileTypes",
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 88
  end,
})