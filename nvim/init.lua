vim.api.nvim_create_autocmd(
  { "BufEnter", "BufRead", "BufNewFile" },
  { pattern = "*.md", command = [[syn match htmlBoldUnderline /`.*[^`]*`/]] }
)

-- set conceal level to work with obsidian.nvim
vim.opt.conceallevel = 1

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- dadbod ui configuration
vim.g.db_ui_save_location = '~/Dropbox/db_ui_queries'

function MMCUtilsExecAndPrint(command)
  local output = vim.fn.system(command)
  print(output)
end

function MMCExecFile()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file_path = vim.api.nvim_buf_get_name(current_buffer)
  print(current_file_path)
  if string.match(current_file_path, ".rb") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("ruby " .. current_file_path)
  end

  if string.match(current_file_path, ".py") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("python " .. current_file_path)
  end

  if string.match(current_file_path, ".go") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("go run " .. current_file_path)
  end

  if string.match(current_file_path, ".sh") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("bash " .. current_file_path)
  end

  if string.match(current_file_path, ".js") then
    print("current_file_path: " .. current_file_path)
    MMCUtilsExecAndPrint("node " .. current_file_path)
  end
end

function ToggleCMDHeight()
  local cmdheight = vim.api.nvim_get_option("cmdheight")
  if cmdheight < 10 then
    vim.opt.cmdheight = 10
  else
    vim.opt.cmdheight = 1
  end
end

vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 1
vim.opt.foldlevelstart = 99

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false

vim.g.mapleader = " "
vim.keymap.set("v", "<C-c>", '"*y :let @+=@*<CR>', { silent = true })
vim.keymap.set("n", "<C-v>", '"+p', { silent = true })
vim.keymap.set("n", "<C-h>", '<c-w>h', {})
vim.keymap.set("n", "<C-j>", '<c-w>j', {})
vim.keymap.set("n", "<C-k>", '<c-w>k', {})
vim.keymap.set("n", "<C-l>", '<c-w>l', {})
vim.keymap.set("n", "<C-n>", vim.cmd.NERDTreeToggle)
vim.keymap.set("i", "<C-b>", '<cmd>lua MMCExecFile()<CR>')
vim.keymap.set("n", "<C-b>", '<cmd>lua MMCExecFile()<CR>')
vim.keymap.set("n", "<leader>tc", '<cmd>lua ToggleCMDHeight()<CR>')
vim.g["NERDTreeShowHidden"] = 1
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.cmd [[packadd packer.nvim]]

require('mmc').setup()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  --use 'David-Kunz/gen.nvim'

  use('preservim/nerdtree')
  use('tpope/vim-fugitive')

  use('jiangmiao/auto-pairs')

  -- open current file on github
  use "almo7aya/openingh.nvim"

  use('github/copilot.vim')

  -- use 'folke/tokyonight.nvim'

  -- vim.cmd("colorscheme tokyonight")

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  use('neovim/nvim-lspconfig')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')

  use("L3MON4D3/LuaSnip")

  use('tpope/vim-surround')
  use('tpope/vim-dadbod')

  use('tpope/vim-commentary')
  use('tpope/vim-markdown')
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  use {
    "folke/which-key.nvim",
    event = "VimEnter",
  }

  use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!
  use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { { "nvim-lua/plenary.nvim" } }
  }

  use {
    'kristijanhusak/vim-dadbod-ui',
    wants = {
      'tpope/vim-dadbod',
    }
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      config = function()
        require("telescope").setup{
          defaults = {
            file_ignore_patterns = {
              "node_modules"
            }
          }
        }
        require("telescope").load_extension("live_grep_args")
      end
    }

  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }

  use {
    'epwalsh/obsidian.nvim',
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "Notes",
            path = "/home/mmc/Dropbox/joplin-markdown-export"
          },
        }
      })
    end,
  }

  -- Debugging
  use {
    "mfussenegger/nvim-dap",
    opt = true,
    event = "BufReadPre",
    module = { "dap" },
    wants = {
      "nvim-dap-virtual-text",
      "nvim-dap-ui",
      "nvim-dap-ruby",
      "nvim-dap-go",
      'nvim-dap-python',
      "telescope.nvim",
      "telescope-dap.nvim",
      "which-key.nvim",
      "one-small-step-for-vimkind",
      "nvim-nio"
    },
    requires = {
      'jbyuki/one-small-step-for-vimkind',
      "0000marcell/nvim-dap-ruby",
      "leoluz/nvim-dap-go",
      'mfussenegger/nvim-dap-python',
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "nvim-telescope/telescope-dap.nvim"
    },
    config = function()
      require("dapconfig").setup()
    end,
  }
end)
