local M = {}

-- Constants for resize amount
local RESIZE_AMOUNT = 15

function M.resize_panel(direction)
    -- Get the current window number
    print("resize_panel_vertical")
    local current_win = vim.api.nvim_get_current_win()
    if direction == 'v_increase' then
      vim.api.nvim_win_set_width(current_win, vim.api.nvim_win_get_width(current_win) + RESIZE_AMOUNT)
    elseif direction == 'v_decrease' then
       vim.api.nvim_win_set_width(current_win, vim.api.nvim_win_get_width(current_win) - RESIZE_AMOUNT)
    elseif direction == 'h_increase' then
       vim.api.nvim_win_set_height(current_win, vim.api.nvim_win_get_width(current_win) + RESIZE_AMOUNT)
    elseif direction == 'h_decrease' then
       vim.api.nvim_win_set_height(current_win, vim.api.nvim_win_get_width(current_win) - RESIZE_AMOUNT)
    end
end

function M.resize_vertical_increase()
  M.resize_panel('v_increase')
end

function M.resize_vertical_decrease()
  M.resize_panel('v_decrease')
end

function M.resize_horizontal_increase()
  M.resize_panel('h_increase')
end

function M.resize_horizontal_decrease()
  M.resize_panel('h_decrease')
end

function M.setup()
  vim.keymap.set('n', '<space><Left>', M.resize_vertical_increase, { noremap = true, silent = true, desc = "Resize panel vertically" })
  vim.keymap.set('n', '<space><Right>', M.resize_vertical_decrease, { noremap = true, silent = true, desc = "Resize panel vertically" })
  vim.keymap.set('n', '<space><Up>', M.resize_horizontal_increase, { noremap = true, silent = true, desc = "Resize panel horizontally increase" })
  vim.keymap.set('n', '<space><Up>', M.resize_horizontal_decrease, { noremap = true, silent = true, desc = "Resize panel horizontally decrease" })
end

return M
