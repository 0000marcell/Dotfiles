local M = {}

function M.setup()
  vim.opt.nu = true
  vim.opt.relativenumber = true

  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.bo.softtabstop = 2
  vim.opt.expandtab = true

  vim.opt.smartindent = true

  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
  vim.opt.undofile = true

  vim.opt.hlsearch = false
  vim.opt.incsearch = true

  vim.opt.termguicolors = true

  vim.opt.updatetime = 50

  vim.opt.colorcolumn = "80"
end

return M
