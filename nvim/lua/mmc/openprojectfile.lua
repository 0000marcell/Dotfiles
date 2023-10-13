function OpenProjectFile()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buffer)
  local current_file_directory = vim.fn.fnamemodify(current_file_path, ":p:h")

  vim.cmd("cd " .. current_file_directory)
  print("Changing Directory To " .. current_file_directory)
end
