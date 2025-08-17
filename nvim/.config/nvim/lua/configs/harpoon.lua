local harpoon = require("harpoon")

-- Harpoon v2 configuration for quick file navigation in large repos
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    mark_branch = true,
    key = function()
      return vim.loop.cwd()
    end,
  },
  default = {
    get_root_dir = function()
      return vim.loop.cwd()
    end,
    select = function(list_item, list, options)
      options = options or {}
      if list_item == nil then
        return
      end
      
      local bufnr = vim.fn.bufnr(list_item.value)
      local set_position = false
      if bufnr == -1 or options.vsplit or options.split or options.tabedit then
        set_position = true
      end
      
      if options.vsplit then
        vim.cmd("vsplit")
      elseif options.split then
        vim.cmd("split")
      elseif options.tabedit then
        vim.cmd("tabedit")
      end
      
      vim.api.nvim_set_current_buf(
        options.tabedit and vim.api.nvim_get_current_buf() or
        vim.fn.bufnr(list_item.value, true)
      )
      
      if set_position and list_item.context then
        local ok, _ = pcall(vim.api.nvim_win_set_cursor, 0, {
          list_item.context.row or 1,
          list_item.context.col or 0,
        })
        if not ok then
          vim.api.nvim_win_set_cursor(0, { 1, 0 })
        end
      end
    end,
  },
})

-- Key mappings for Harpoon
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })