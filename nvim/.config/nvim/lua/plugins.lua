return { -- the colorscheme should be available when starting Neovim
{
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme tokyonight]])
    end
}, -- I have a separate config.mappings file where I require which-key.
-- With lazy the plugin will be automatically loaded when it is required somewhere
{
    "folke/which-key.nvim",
    lazy = true
}, {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    ft = "norg",
    -- options for neorg. This will automatically call `require("neorg").setup(opts)`
    opts = {
        load = {
            ["core.defaults"] = {}
        }
    }
}, {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
        vim.g.startuptime_tries = 10
    end
}, {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer"},
    config = function()
        -- ...
    end
}, -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
-- So for api plugins like devicons, we can always set lazy=true
{
    "nvim-tree/nvim-web-devicons",
    lazy = true
}, -- you can use the VeryLazy event for things that can
-- load later and are not important for the initial UI
{
    "stevearc/dressing.nvim",
    event = "VeryLazy"
}, {
    "Wansmer/treesj",
    keys = {{
        "J",
        "<cmd>TSJToggle<cr>",
        desc = "Join Toggle"
    }},
    opts = {
        use_default_keymaps = false,
        max_join_length = 150
    }
}, {
    "monaqa/dial.nvim",
    -- lazy-load on keys
    -- mode is `n` by default. For more advanced options, check the section on key mappings
    keys = {"<C-a>", {
        "<C-x>",
        mode = "n"
    }}
}, -- local plugins need to be explicitly configured with dir
{
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = { -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim", -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify"}
}}
