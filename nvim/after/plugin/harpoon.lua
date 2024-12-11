local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 20, -- Adjust width as needed
        -- Define how the file name is displayed
        -- Options:
        -- 'absolute': Full absolute path
        -- 'relative': Path relative to the current working directory
        -- 'filename': Only the file name (default)
        show_filename_only = true, -- Show just the file name
    },
})
-- REQUIRED

local M = {}

local function write_to_file(content)
  local file = io.open("harpoon_log.txt", "w")
  file:write(content)
  file:close()
end

function M.log()
  local list = harpoon:list()
  local content = vim.inspect(list)
  -- write_to_file(content)
  harpoon.ui:toggle_quick_menu(list)
end

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>e", M.log)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)
