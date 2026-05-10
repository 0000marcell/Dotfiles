return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        herb_ls = {
          init_options = {
            formatter = "auto",
          },
        },
      },
    },
  },
}
