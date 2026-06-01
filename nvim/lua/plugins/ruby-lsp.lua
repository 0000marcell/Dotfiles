return {
  {
    "adam12/ruby-lsp.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("ruby-lsp").setup({
        -- Forwards configurations to lspconfig's ruby_lsp setup
        lspconfig = {
          init_options = {
            formatter = "rubocop", -- or 'standard'
            linters = { "rubocop" },
          },
        },
      })
    end,
  },
}

-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         ruby_lsp = {
--           cmd = { "ruby-lsp" },
--           filetypes = { "ruby" },
--           root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
--           init_options = {
--             formatter = "auto",
--             enabledFeatures = {
--               "documentHighlights",
--               "documentSymbols",
--               "foldingRanges",
--               "selectionRanges",
--               "semanticHighlighting",
--               "formatting",
--               "codeActions",
--               "diagnostics",
--               "completion",
--               "definition",
--               "workspaceSymbol",
--             },
--             experimentalFeaturesEnabled = true,
--           },
--           settings = {},
--         },
--       },
--     },
--   },
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = function(_, opts)
--       vim.list_extend(opts.ensure_installed, { "ruby" })
--     end,
--   },
-- }
