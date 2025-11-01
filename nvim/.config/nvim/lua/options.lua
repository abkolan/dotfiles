require "nvchad.options"

local o = vim.o
local g = vim.g

-- Performance optimizations for large monorepos
o.cursorlineopt = 'both'
o.updatetime = 250
o.timeoutlen = 300
o.redrawtime = 10000
o.maxmempattern = 20000
o.synmaxcol = 240

-- Better search experience
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

-- Better file handling
o.hidden = true
o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = true
o.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Better completion
o.completeopt = "menu,menuone,noselect"
o.pumheight = 10
o.pumblend = 10

-- Better split behavior
o.splitbelow = true
o.splitright = true

-- Better scrolling
o.scrolloff = 8
o.sidescrolloff = 8

-- Better indentation
o.smartindent = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2

-- Better line numbers
o.number = true
o.relativenumber = true

-- Better visual experience
o.termguicolors = true
o.signcolumn = "yes"
o.colorcolumn = "80,120"
o.wrap = true
o.linebreak = true

-- Fold settings for UFO
o.foldcolumn = '1'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- Global settings (leader keys already set in init.lua)

-- Disable some providers for faster startup
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Better grep program
if vim.fn.executable("rg") == 1 then
  o.grepprg = "rg --vimgrep --smart-case --hidden"
  o.grepformat = "%f:%l:%c:%m"
end

-- Auto commands for large file handling
vim.api.nvim_create_augroup("LargeFileOptimizations", { clear = true })

-- Disable features for large files (>1MB)
vim.api.nvim_create_autocmd("BufReadPre", {
  group = "LargeFileOptimizations",
  callback = function()
    local file = vim.fn.expand("<afile>")
    local size = vim.fn.getfsize(file)
    if size > 1024 * 1024 then -- 1MB
      vim.cmd("syntax off")
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.wrap = false
    end
  end,
})

-- Auto save when focus is lost or buffer is switched
vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = "AutoSave",
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! update")
    end
  end,
})

-- Highlight yanked text
vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "HighlightYank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function() vim.cmd([[%s/\s\+$//e]]) end)
    vim.fn.setpos(".", save_cursor)
  end,
})
