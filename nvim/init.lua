require('mmc').setup()

vim.api.nvim_create_autocmd(
{ "BufEnter", "BufRead", "BufNewFile" },
{ pattern = "*.md", command = [[syn match htmlBoldUnderline /`.*[^`]*`/]] }
)

-- set conceal level to work with obsidian.nvim
vim.opt.conceallevel = 1


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
vim.opt.ignorecase = true
vim.keymap.set("v", "<C-c>", '"*y :let @+=@*<CR>', { silent = true })
vim.keymap.set("n", "<C-v>", '"+p', { silent = true })
vim.keymap.set("n", "<C-h>", '<c-w>h', {})
vim.keymap.set("n", "<C-j>", '<c-w>j', {})
vim.keymap.set("n", "<C-k>", '<c-w>k', {})
vim.keymap.set("n", "<C-l>", '<c-w>l', {})
vim.keymap.set("n", "<C-n>", vim.cmd.NERDTreeToggle)
vim.keymap.set("i", "<C-b>", '<cmd>lua MMCExecFile()<CR>')
vim.keymap.set("n", "<C-b>", '<cmd>lua MMCExecFile()<CR>')
vim.g["NERDTreeShowHidden"] = 1
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "J", "<C-d>")
vim.keymap.set("n", "K", "<C-b>")

-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Lazy.nvim can manage itself
    "folke/lazy.nvim",

    -- Core Plugins
    { "preservim/nerdtree" },
    { "tpope/vim-fugitive" },
    { "jiangmiao/auto-pairs" },
    {
      "folke/tokyonight.nvim",
      lazy = false, -- Load immediately
      priority = 1000, -- Ensure it loads before other plugins
      config = function()
        -- Optional configuration
        require("tokyonight").setup({
          style = "storm", -- Choose "storm", "moon", "night", or "day"
          transparent = true,
          terminal_colors = true,
          styles = {
            comments = { italic = true },
            keywords = { italic = false },
            functions = { bold = true },
          },
        })
        -- Apply the colorscheme
        vim.cmd([[colorscheme tokyonight]])
      end,
    },
    -- Open current file on GitHub
    { "almo7aya/openingh.nvim" },

    { "neovimhaskell/haskell-vim" },

    -- GitHub Copilot
    -- { "github/copilot.vim" },

    -- LSP and Completion
    -- { "neovim/nvim-lspconfig" },
    -- { "hrsh7th/nvim-cmp" },
    -- { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },

    -- Text Manipulation
    { "tpope/vim-surround" },
    { "tpope/vim-dadbod" },
    { "tpope/vim-commentary" },
    { "tpope/vim-markdown" },

    -- Markdown Preview
    {
      "iamcco/markdown-preview.nvim",
      build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Which-Key
    {
      "folke/which-key.nvim",
      dependencies = {
        "echasnovski/mini.icons",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      event = "VeryLazy",
    },

    -- Harpoon
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Dadbod UI
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = { "tpope/vim-dadbod" },
    },

    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.2",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
      },
      config = function()
        require("telescope").setup({
          defaults = {
            file_ignore_patterns = { "node_modules" },
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                prompt_position = "top",
                preview_width = 0.6,
              },
              vertical = {
                preview_height = 0.5,
              },
              -- Enable this to show the preview at the bottom
              bottom_pane = {
                height = 0.4,
                preview_cutoff = 120,
              },
            },
            sorting_strategy = "ascending",
          },
        })
        require("telescope").load_extension("live_grep_args")
      end,
    },

    -- Obsidian
    {
      "epwalsh/obsidian.nvim",
      config = function()
        require("obsidian").setup({
          workspaces = {
            { name = "Current", path = "/home/mmc/Dropbox/obsidian-vaults/current" },
            { name = "Old", path = "/home/mmc/Dropbox/obsidian-vaults/old" },
          },
          follow_url_func = function(url)
            vim.fn.jobstart({ "xdg-open", url }) -- Linux
          end,
        })
      end,
    },

    -- Avante.nvim
    {
      "yetone/avante.nvim",
      event = "BufRead",
      build = "make",
      config = function()
        require("avante").setup({
          provider='copilot',
          windows = {
            width = 80,
          },
        })
      end,
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        { "hrsh7th/nvim-cmp", lazy = true },
        { "nvim-tree/nvim-web-devicons", lazy = true },
        { "zbirenbaum/copilot.lua", lazy = true },
        {
          "HakonHarnes/img-clip.nvim",
          config = function()
            require("img-clip").setup({
              default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = { insert_mode = true },
                use_absolute_path = true,
              },
            })
          end,
        },
        {
          "MeanderingProgrammer/render-markdown.nvim",
          ft = { "markdown", "Avante" },
          config = function()
            require("render-markdown").setup({ file_types = { "markdown", "Avante" } })
          end,
        },
      },
    },

    -- Debugging (nvim-dap)
    {
      "mfussenegger/nvim-dap",
      lazy = true,
      event = "BufReadPre",
      module = { "dap" },
      dependencies = {
        "jbyuki/one-small-step-for-vimkind",
        "0000marcell/nvim-dap-ruby",
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "nvim-telescope/telescope-dap.nvim",
      },
      config = function()
        require("dapconfig").setup()
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})


