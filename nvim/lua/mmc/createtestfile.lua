local M = {}

function M.createtestfile()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buffer)
  if !string.match(current_file_path, "%.jsx$") then
    print("path does not contain .jsx extension")
    return
  end

  local new_path = string.gsub(current_file_path, ".jsx", ".test.jsx")

  print(new_path)

  local file = io.open(new_path, "w")

  if file then
    file:write("This is some content written to the file.\n")
    file:write("Another line of content.\n")
    file:close()
    print("File created successfully.")
  else
    print("Error: Unable to create file.")
  end
end

function M.setup()
  vim.keymap.set("n", "<leader>ct", M.createtestfile, { silent = true })
end

return M
