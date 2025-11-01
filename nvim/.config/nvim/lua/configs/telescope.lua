local telescope = require("telescope")
local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

-- Advanced Telescope configuration for massive monorepos
telescope.setup({
  defaults = {
    -- Use ripgrep for blazing fast search
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading", 
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/*",
      "--glob=!node_modules/*",
      "--glob=!.terraform/*",
      "--glob=!target/*",
      "--glob=!build/*",
      "--glob=!dist/*",
      "--glob=!*.min.js",
      "--glob=!*.min.css",
      "--glob=!vendor/*",
    },
    -- Performance optimizations for large repos
    file_ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.terraform/",
      "target/",
      "build/",
      "dist/",
      "%.min%.js",
      "%.min%.css",
      "vendor/",
      "%.lock",
      "%.log",
      "%.cache",
      "%.jpg",
      "%.jpeg", 
      "%.png",
      "%.gif",
      "%.svg",
      "%.ico",
      "%.pdf",
      "%.zip",
      "%.tar%.gz",
      "%.class",
      "%.o",
      "%.so",
      "%.dylib",
      "%.dll",
      "%.exe",
    },
    prompt_prefix = " 🔍 ",
    selection_caret = " ➤ ",
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Buffer previewer config for large files
    buffer_previewer_maker = function(filepath, bufnr, opts)
      opts = opts or {}
      filepath = vim.fn.expand(filepath)
      vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then return end
        if stat.size > 100000 then
          return
        else
          require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
        end
      end)
    end,
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Optimized for large monorepos
    find_files = {
      find_command = { 
        "fd", 
        "--type", "f", 
        "--hidden", 
        "--follow",
        "--exclude", ".git",
        "--exclude", "node_modules",
        "--exclude", ".terraform",
        "--exclude", "target", 
        "--exclude", "build",
        "--exclude", "dist",
        "--exclude", "vendor",
      },
      layout_config = {
        height = 0.8,
        width = 0.8,
        prompt_position = "top",
      },
      sorting_strategy = "ascending",
      theme = "dropdown",
      previewer = false, -- Disable previewer for faster navigation
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden", "--glob", "!.git/*"}
      end,
      layout_config = {
        height = 0.9,
        width = 0.9,
      },
    },
    grep_string = {
      additional_args = function(opts)
        return {"--hidden", "--glob", "!.git/*"}
      end,
    },
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        }
      }
    },
    git_files = {
      show_untracked = true,
      layout_config = {
        height = 0.8,
        width = 0.8,
      },
    },
    lsp_references = {
      layout_config = {
        height = 0.9,
        width = 0.9,
      },
    },
    lsp_document_symbols = {
      layout_config = {
        height = 0.9,
        width = 0.9,
      },
    },
    lsp_workspace_symbols = {
      layout_config = {
        height = 0.9,
        width = 0.9,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    },
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<A-c>"] = require("telescope._extensions.file_browser.actions").create,
          ["<S-CR>"] = require("telescope._extensions.file_browser.actions").create_from_prompt,
          ["<A-r>"] = require("telescope._extensions.file_browser.actions").rename,
          ["<A-m>"] = require("telescope._extensions.file_browser.actions").move,
          ["<A-y>"] = require("telescope._extensions.file_browser.actions").copy,
          ["<A-d>"] = require("telescope._extensions.file_browser.actions").remove,
          ["<C-o>"] = require("telescope._extensions.file_browser.actions").open,
          ["<C-g>"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
          ["<C-e>"] = require("telescope._extensions.file_browser.actions").goto_home_dir,
          ["<C-w>"] = require("telescope._extensions.file_browser.actions").goto_cwd,
          ["<C-t>"] = require("telescope._extensions.file_browser.actions").change_cwd,
          ["<C-f>"] = require("telescope._extensions.file_browser.actions").toggle_browser,
          ["<C-h>"] = require("telescope._extensions.file_browser.actions").toggle_hidden,
          ["<C-s>"] = require("telescope._extensions.file_browser.actions").toggle_all,
        },
        ["n"] = {
          ["c"] = require("telescope._extensions.file_browser.actions").create,
          ["r"] = require("telescope._extensions.file_browser.actions").rename,
          ["m"] = require("telescope._extensions.file_browser.actions").move,
          ["y"] = require("telescope._extensions.file_browser.actions").copy,
          ["d"] = require("telescope._extensions.file_browser.actions").remove,
          ["o"] = require("telescope._extensions.file_browser.actions").open,
          ["g"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
          ["e"] = require("telescope._extensions.file_browser.actions").goto_home_dir,
          ["w"] = require("telescope._extensions.file_browser.actions").goto_cwd,
          ["t"] = require("telescope._extensions.file_browser.actions").change_cwd,
          ["f"] = require("telescope._extensions.file_browser.actions").toggle_browser,
          ["h"] = require("telescope._extensions.file_browser.actions").toggle_hidden,
          ["s"] = require("telescope._extensions.file_browser.actions").toggle_all,
        },
      },
    },
    undo = {
      side_by_side = true,
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.8,
      },
    },
  },
})

-- Load extensions (terraform and yaml_schema are loaded by their respective plugins)
telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("file_browser")
telescope.load_extension("undo")

-- Custom functions for monorepo navigation
local M = {}

-- Find files in specific directories (common monorepo patterns)
M.find_files_in_services = function()
  require("telescope.builtin").find_files({
    prompt_title = "Services",
    cwd = vim.fn.getcwd() .. "/services",
    hidden = true,
  })
end

M.find_files_in_packages = function()
  require("telescope.builtin").find_files({
    prompt_title = "Packages", 
    cwd = vim.fn.getcwd() .. "/packages",
    hidden = true,
  })
end

M.find_files_in_apps = function()
  require("telescope.builtin").find_files({
    prompt_title = "Apps",
    cwd = vim.fn.getcwd() .. "/apps", 
    hidden = true,
  })
end

-- Search by file extension
M.find_by_extension = function(ext)
  require("telescope.builtin").find_files({
    prompt_title = string.format("Find .%s files", ext),
    find_command = { "fd", "--extension", ext, "--type", "f", "--hidden" },
  })
end

-- Smart workspace search based on git root
M.smart_find_files = function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    require("telescope.builtin").find_files()
  else
    require("telescope.builtin").find_files({ cwd = git_root })
  end
end

-- Find recent files with frecency
M.find_recent_files = function()
  require("telescope.builtin").oldfiles({
    prompt_title = "Recent Files",
    only_cwd = true,
  })
end

-- Multi-grep with args for complex searches
M.multi_grep = function()
  require("telescope").extensions.live_grep_args.live_grep_args({
    prompt_title = "Multi Grep",
  })
end

-- Find TODO comments across the entire codebase
M.find_todos = function()
  require("telescope.builtin").grep_string({
    prompt_title = "Find TODOs",
    search = "TODO\\|FIXME\\|HACK\\|BUG\\|NOTE",
    use_regex = true,
  })
end

return M