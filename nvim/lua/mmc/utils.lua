function ListOpenBuffers()
  local buffer_list = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffer_list) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    print(buf_name)
  end
end
