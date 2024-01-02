local M = {}

function M.currentfileclipboard()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buffer)
  local output = vim.fn.system("echo '" .. current_file_path .. "' | xclip -selection Clipboard")
  print(output)
end

function M.setup()
  vim.keymap.set("n", "<leader>cf", M.currentfileclipboard, { silent = true })
end

return M
