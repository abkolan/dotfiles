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

-- Setup user commands for Kubernetes YAML.
-- Note: yamlls auto-attaches to yaml buffers via filetype, and the schema
-- matching in configs/yamlls.lua (plus filetype.lua's yaml.kubernetes detection)
-- already covers Kubernetes manifests, so no manual client attach is needed.
function M.setup()
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