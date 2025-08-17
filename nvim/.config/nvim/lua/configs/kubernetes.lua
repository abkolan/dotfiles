-- Kubernetes YAML detection and schema configuration
local M = {}

-- Function to detect if a buffer contains Kubernetes YAML
function M.is_kubernetes_yaml(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  -- Check first 50 lines for Kubernetes markers
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(50, vim.api.nvim_buf_line_count(bufnr)), false)
  local content = table.concat(lines, "\n")
  
  -- Look for Kubernetes API markers
  if content:match("apiVersion:") and content:match("kind:") then
    -- Check for common Kubernetes kinds
    local k8s_kinds = {
      "Pod", "Service", "Deployment", "StatefulSet", "DaemonSet", 
      "ReplicaSet", "Job", "CronJob", "ConfigMap", "Secret",
      "Ingress", "NetworkPolicy", "ServiceAccount", "Role", 
      "ClusterRole", "RoleBinding", "ClusterRoleBinding",
      "PersistentVolume", "PersistentVolumeClaim", "StorageClass",
      "Namespace", "ResourceQuota", "LimitRange", "HorizontalPodAutoscaler"
    }
    
    for _, kind in ipairs(k8s_kinds) do
      if content:match("kind:%s*" .. kind) then
        return true
      end
    end
  end
  
  -- Check filename patterns
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename:match("k8s/") or 
     filename:match("kubernetes/") or
     filename:match("manifests/") or
     filename:match("%.k8s%.ya?ml$") then
    return true
  end
  
  return false
end

-- Setup autocommand for YAML files
function M.setup()
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.yaml", "*.yml"},
    callback = function(args)
      if M.is_kubernetes_yaml(args.buf) then
        -- Set up Kubernetes-specific settings
        vim.b[args.buf].yaml_schema = "kubernetes"
        
        -- Force LSP to use Kubernetes schema
        vim.lsp.buf_attach_client(args.buf, vim.lsp.get_clients({name = "yamlls"})[1])
        
        -- Optional: Add modeline comment for explicit schema
        -- vim.api.nvim_buf_set_lines(args.buf, 0, 0, false, {"# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone-strict/all.json"})
      end
    end,
  })
  
  -- Command to manually set Kubernetes schema
  vim.api.nvim_create_user_command("K8sSchema", function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.b[bufnr].yaml_schema = "kubernetes"
    vim.notify("Kubernetes schema applied", vim.log.levels.INFO)
    -- Restart LSP for this buffer
    vim.cmd("LspRestart yamlls")
  end, {})
end

return M