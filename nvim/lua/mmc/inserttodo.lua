local M = {}

function M.inserttodo(command)
  local line = vim.api.nvim_get_current_line() -- Get the current line
  local col = vim.api.nvim_win_get_cursor(0)[2] -- Get the column position of the cursor

  -- Insert '[] - ' at the beggining of the line 
  local modified_line = '[] - ' .. line

  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  print(modified_line)
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, {modified_line})
  -- vim.api.nvim_set_current_line(modified_line)

  -- Move the cursor to the right by 3 positions to position it between the brackets
  --vim.api.nvim_win_set_cursor(0, {0, col + 3})
end

function M.setup()
  vim.keymap.set("n", "<leader>cb", M.inserttodo, { silent = true })
  vim.keymap.set("i", "<leader>cb", M.inserttodo, { silent = true })
end

return M
