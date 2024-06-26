local M = {}

function M.setup()
  vim.g.mapleader = " "

  vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
  vim.keymap.set("n", "<C-n>", vim.cmd.NERDTreeToggle)
  -- copy and paste
  vim.keymap.set("v", "<C-c>", '"*y :let @+=@*<CR>', { silent=true })
  vim.keymap.set("n", "<C-v>", '"+p', { silent=true})

  vim.keymap.set("n", "<C-h>", '<c-w>h', {})
  vim.keymap.set("n", "<C-j>", '<c-w>j', {})
  vim.keymap.set("n", "<C-k>", '<c-w>k', {})
  vim.keymap.set("n", "<C-l>", '<c-w>l', {})
  -- execute selected ruby
  vim.keymap.set("v", "<leader>r", ":w !ruby<CR>", { noremap=true})

  -- execute selected python 
  vim.keymap.set("v", "<leader>p", ":w !python<CR>")

  -- show information about current ruby test in new split buffer
  vim.keymap.set("n", "<leader>ti", "<cmd>lua ShowTestInfo()<CR>")

  -- open project 
  vim.keymap.set("n", "<leader>o", '<cmd>lua OpenProject()<CR>')

  -- open current open file projects 
  vim.keymap.set("n", "<leader>i", '<cmd>lua OpenProjectFile()<CR>')

  --reload vimrc
  vim.keymap.set("n", "<leader><leader>", '<cmd>source $MYVIMRC<CR>')

  -- move highlighted text
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

  -- don't move curser when concatenating lines
  vim.keymap.set("n", "J", "mzJ`z")


  -- half page jumping keeps cursor in the middle
  vim.keymap.set("n", "<C-d>", "<C-d>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")
end

return M
