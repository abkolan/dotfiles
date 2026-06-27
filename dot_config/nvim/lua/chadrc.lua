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
      highlight = { enable = true },
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
  -- 5) Indent guides (disabled)
  ["lukas-reineke/indent-blankline.nvim"] = {
    enabled = false,
  },
}

return M
