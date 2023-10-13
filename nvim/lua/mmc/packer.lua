local M = {}

function M.setup()
  -- This file can be loaded by calling `lua require('plugins')` from your init.vim

  -- Only required if you have packer configured as `opt`
  vim.cmd [[packadd packer.nvim]]

  return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.2',
      -- or                            , branch = '0.1.x',
      requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({ 'rose-pine/neovim', as = 'rose-pine' })

    vim.cmd('colorscheme rose-pine')

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use('nvim-treesitter/playground')

    use('ThePrimeagen/harpoon')

    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use('scrooloose/nerdtree')

    use('tpope/vim-commentary')

    use('neovim/nvim-lspconfig')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-cmdline')
    use('hrsh7th/nvim-cmp')
    use('saadparwaiz1/cmp_luasnip')
    use('Raimondi/delimitMate')
    use('gabrielelana/vim-markdown')
    use({ "L3MON4D3/LuaSnip", run = "make install_jsregexp" })
    use("rafamadriz/friendly-snippets")

    -- WhichKey
    use {
      "folke/which-key.nvim",
      event = "VimEnter",
    }

    -- Debugging
    use {
      "mfussenegger/nvim-dap",
      opt = true,
      event = "BufReadPre",
      module = { "dap" },
      requires = {
        'suketa/nvim-dap-ruby',
        "Pocco81/DAPInstall.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        { "leoluz/nvim-dap-go",                module = "dap-go" },
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      },
      wants = {
        "telescope.nvim",
        "telescope-dap.nvim",
        "nvim-dap-virtual-text",
        "DAPInstall.nvim",
        "nvim-dap-ui",
        "nvim-dap-ruby",
        "nvim-dap-python",
        "nvim-dap-go",
        "one-small-step-for-vimkind",
        "which-key.nvim"
      },
      config = function()
        require('dap').set_log_level('TRACE')
        require("mmc.dap").setup()
      end,
    }
  end)
end

return M
