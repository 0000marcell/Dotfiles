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

-- execute python
vim.keymap.set("i", "<C-b>", '<cmd>! python %<CR>')
vim.keymap.set("n", "<C-b>", '<cmd>! python %<CR>')

-- open project 
vim.keymap.set("n", "<leader>o", '<cmd>lua OpenProject()<CR>')

--reload vimrc
vim.keymap.set("n", "<leader><leader>", '<cmd>source $MYVIMRC<CR>')
