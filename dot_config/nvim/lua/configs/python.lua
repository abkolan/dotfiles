-- Shared helper for resolving the Python interpreter path.
--
-- Previously this logic was duplicated in three places (configs/lspconfig.lua,
-- the nvim-dap-python plugin spec, and the neotest plugin spec). It shells out
-- synchronously to `pipenv --venv`; that is preserved here for behavioral
-- parity. The three historical call sites differed slightly (workspace-scoped
-- lookup, file-existence verification, and fallback), so those differences are
-- exposed as options to keep each caller's behavior identical.
--
-- Options (all optional):
--   workspace  string  Directory to run pipenv in (cd into it first). When nil,
--                      pipenv runs in the current working directory.
--   verify     boolean When true, only return the pipenv python if the file
--                      actually exists on disk.
--   fallback   any     Value (or function returning a value) used when no
--                      pipenv venv is found. Defaults to system python3/python.

local function get_python_path(opts)
  opts = opts or {}

  local cmd = "pipenv --venv 2>/dev/null"
  if opts.workspace then
    cmd = string.format("cd '%s' && %s", opts.workspace, cmd)
  end

  local handle = io.popen(cmd)
  if handle then
    local venv_path = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if venv_path ~= "" and venv_path ~= "nil" then
      local python_path = venv_path .. "/bin/python"
      if not opts.verify or vim.fn.filereadable(python_path) == 1 then
        return python_path
      end
    end
  end

  local fallback = opts.fallback
  if type(fallback) == "function" then
    return fallback()
  elseif fallback ~= nil then
    return fallback
  end

  -- Default fallback to system python.
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return get_python_path
