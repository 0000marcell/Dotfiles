local luasnip = require('luasnip')

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set("i", "<Tab>", luasnip.expand_or_jump)
