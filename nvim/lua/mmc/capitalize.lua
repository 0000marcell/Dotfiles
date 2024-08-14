local M = {}

function M.capitalize()
  local current_line = vim.api.nvim_get_current_line()
  local new_line = current_line:gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
  vim.api.nvim_set_current_line(new_line)
end

function M.setup()
  vim.keymap.set("n", "<leader>ca", M.capitalize, { silent = true })
end

return M
