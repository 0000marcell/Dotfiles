local M = {}

function M.list_buffers()
  local buffer_list = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffer_list) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    print(buf_name)
  end
end

function M.exec_and_print(command)
  local output = vim.fn.system(command)
  print(output)
end

return M
