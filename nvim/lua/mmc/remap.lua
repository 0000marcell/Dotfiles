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

-- execute code 
vim.keymap.set("i", "<C-b>", '<cmd>lua ExecFile()<CR>')
vim.keymap.set("n", "<C-b>", '<cmd>lua ExecFile()<CR>')

-- print current file full path
vim.keymap.set("n", "<leader>cf", "<cmd>echo expand('%:p')<CR>")

-- show information about current ruby test in new split buffer
vim.keymap.set("n", "<leader>ti", "<cmd>lua ShowTestInfo()<CR>")

-- open project 
vim.keymap.set("n", "<leader>o", '<cmd>lua OpenProject()<CR>')

-- open current open file projects 
vim.keymap.set("n", "<leader>i", '<cmd>lua OpenProjectFile()<CR>')

--reload vimrc
vim.keymap.set("n", "<leader><leader>", '<cmd>source $MYVIMRC<CR>')
