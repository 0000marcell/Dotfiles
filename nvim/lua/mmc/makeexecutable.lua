local M = {}

function M.makeExecutable()
  local current_file = vim.fn.expand('%:p')
  local chmod_command = 'chmod +x ' .. current_file
  vim.fn.system(chmod_command)
  print('Made ' .. current_file .. ' executable')
end

function M.setup()
  vim.keymap.set("n", "<leader>me", M.makeExecutable, { silent = true })
end

return M
