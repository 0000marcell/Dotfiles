vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  group = vim.api.nvim_create_augroup("open_find_files_on_start", { clear = true }),
  once = true,
  callback = function()
    vim.schedule(function()
      LazyVim.pick("files")()
    end)
  end,
})

require("config.lazy")
