function MMCExecFile()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buffer)
  print(current_file_path)
  if string.match(current_file_path, ".rb") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("ruby " .. current_file_path)
  end

  if string.match(current_file_path, ".py") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("python " .. current_file_path)
  end

  if string.match(current_file_path, ".go") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("go run " .. current_file_path)
  end

  if string.match(current_file_path, ".sh") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("bash " .. current_file_path)
  end
end
