local M = {}

function M.set_cursor_pos_end()
  local line = vim.api.nvim_get_current_line()
  local col = string.len(line)
  local current_line_number = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, {current_line_number, col})
end

function M.inserttodo(command)
  local line = vim.api.nvim_get_current_line() -- Get the current line
  local col = vim.api.nvim_win_get_cursor(0)[2] -- Get the column position of the cursor

  -- Insert '[] - ' at the beggining of the line 
  local modified_line = '[  ] - ' .. line

  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  print(modified_line)
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, {modified_line})
  M.set_cursor_pos_end()
end

function M.setup()
  vim.keymap.set("n", "<leader>cb", M.inserttodo, { silent = true })
  -- vim.keymap.set("i", "<leader>cb", M.inserttodo, { silent = true })
end

return M
