-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function open_file_picker_on_start()
  if vim.fn.argc() > 0 or vim.bo.filetype ~= "" or vim.api.nvim_buf_get_name(0) ~= "" then
    return
  end
  Snacks.picker.files({ cwd = vim.fn.getcwd() })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.schedule(open_file_picker_on_start)
  end,
})
