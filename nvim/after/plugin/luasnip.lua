local luasnip = require('luasnip')

--require("luasnip.loaders.from_vscode").lazy_load()

--require'luasnip'.filetype_extend("ruby", {"rails"})

require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })

vim.keymap.set("i", "<Tab>", luasnip.expand_or_jump)
