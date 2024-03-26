local M = {}

function M.copyFile(source_path, destination_path)
  -- Build the shell command to copy the file
  local command = "cp " .. source_path .. " " .. destination_path

  -- Execute the shell command
  local success, error_message, error_code = os.execute(command)

  -- Check if the command executed successfully
  if success then
      print("File copied successfully")
  else
      print("Error:", error_message, "Error code:", error_code)
  end
end

function M.createtestfile()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buffer)
  if not string.match(current_file_path, "%.jsx$") then
    print("path does not contain .jsx extension")
    return
  end

  local new_path = string.gsub(current_file_path, ".jsx", ".test.jsx")

  print(new_path)

  local configDir = vim.fn.stdpath('config')

  print("Neovim configuration directory:", configDir)

  M.copyFile(configDir .. "/testtemplates/test.jsx", new_path)
end

function M.setup()
  vim.keymap.set("n", "<leader>ct", M.createtestfile, { silent = true })
end

return M
