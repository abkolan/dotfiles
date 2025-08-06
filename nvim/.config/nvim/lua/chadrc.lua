-- ~/.config/nvim/lua/plugins/chadrc.lua
---@type ChadrcConfig
local M = {}

-- 1) Base theme and highlights
M.base46 = {
  theme = "gruvbox",
  -- hl_override = {
  --   Comment     = { italic = true },
  --   ["@comment"] = { italic = true },
  -- },
}

-- 2) NVDash settings
M.nvdash = {
  load_on_startup = true,
}

-- 3) UI tweaks
M.ui = {
  tabufline = {
    lazyload = false,
  },
}

--───────────────────────────────────────────────────────
-- 4) Plugin declarations & overrides
--───────────────────────────────────────────────────────
M.plugins = {
  -- a) Blink (NVChad built‑in spec)
  { import = "nvchad.blink.lazyspec" },

  -- b) Treesitter: ensure these parsers are installed
  ["nvim-treesitter/nvim-treesitter"] = {
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
  -- Fuzzy‑finder (Lua-native)
  ["ibhagwan/fzf-lua"] = {
    requires = { "nvim-tree/nvim-web-devicons" },
    cmd      = { "FzfLua", "Files", "Buffers" },
    config   = function() require("configs.fzf-lua") end,
  },
  -- 3) Statusline
  ["nvim-lualine/lualine.nvim"] = {
    requires = "nvim-tree/nvim-web-devicons",
    event    = "VimEnter",
    config   = function() require("configs.lualine") end,
  },
    -- 5) Indent guides
  ["lukas-reineke/indent-blankline.nvim"] = {
    event  = "BufReadPre",
    config = function() require("configs.indent-blankline") end,
  },
}

return M
