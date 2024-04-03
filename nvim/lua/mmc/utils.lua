local U = {}

function U.list_buffers()
  local buffer_list = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffer_list) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    print(buf_name)
  end
end

function U.exec_and_print(command)
  --print(command)
  local c = "ruby /home/mmc/tmp.rb"
  print(vim.fn.system(c))
end

return U
