function NewBuffer(lines)
  local new_buffer = vim.api.nvim_create_buf(true, true) -- Create a new buffer
  vim.api.nvim_buf_set_lines(new_buffer, 0, -1, false, lines)
  vim.api.nvim_command('vsplit')
  vim.api.nvim_command('buffer ' .. new_buffer)
end

function ShowTestInfo()
  local current_buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)
  local result_lines = {}
  for _, line in ipairs(lines) do
    if string.match(line, "describe ") or
       string.match(line, "it ") or
       string.match(line, "context ") then
      table.insert(result_lines, line)
    end
  end

  NewBuffer(result_lines)
end
