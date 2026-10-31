-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("no_dir_explorer", { clear = true }),
  nested = true,
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" and vim.fn.isdirectory(name) == 1 then
      vim.cmd.cd(name)
      vim.api.nvim_buf_delete(buf, { force = true })
      pcall(function()
        require("snacks").dashboard()
      end)
    end
  end,
})
