-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/mmc/.cache/nvim/packer_hererocks/2.1.1727870382/share/lua/5.1/?.lua;/home/mmc/.cache/nvim/packer_hererocks/2.1.1727870382/share/lua/5.1/?/init.lua;/home/mmc/.cache/nvim/packer_hererocks/2.1.1727870382/lib/luarocks/rocks-5.1/?.lua;/home/mmc/.cache/nvim/packer_hererocks/2.1.1727870382/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/mmc/.cache/nvim/packer_hererocks/2.1.1727870382/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["auto-pairs"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/auto-pairs",
    url = "https://github.com/jiangmiao/auto-pairs"
  },
  ["avante.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vavante\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/avante.nvim",
    url = "https://github.com/yetone/avante.nvim"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["copilot.lua"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/copilot.lua",
    url = "https://github.com/zbirenbaum/copilot.lua"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  harpoon = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  ["img-clip.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\fdefault\1\0\1\fdefault\0\18drag_and_drop\1\0\1\16insert_mode\2\1\0\4\26embed_image_as_base64\1\22use_absolute_path\2\18drag_and_drop\0\25prompt_for_file_name\1\nsetup\rimg-clip\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/img-clip.nvim",
    url = "https://github.com/HakonHarnes/img-clip.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["mini.icons"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/mini.icons",
    url = "https://github.com/echasnovski/mini.icons"
  },
  nerdtree = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/nerdtree",
    url = "https://github.com/preservim/nerdtree"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    after = { "nvim-dap-python", "one-small-step-for-vimkind", "nvim-dap-ruby", "nvim-dap-virtual-text", "nvim-nio", "telescope-dap.nvim", "nvim-dap-go", "nvim-dap-ui" },
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14dapconfig\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap",
    wants = { "nvim-dap-virtual-text", "nvim-dap-ui", "nvim-dap-ruby", "nvim-dap-go", "nvim-dap-python", "telescope.nvim", "telescope-dap.nvim", "which-key.nvim", "one-small-step-for-vimkind", "nvim-nio" }
  },
  ["nvim-dap-go"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/nvim-dap-go",
    url = "https://github.com/leoluz/nvim-dap-go"
  },
  ["nvim-dap-python"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ruby"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/nvim-dap-ruby",
    url = "https://github.com/0000marcell/nvim-dap-ruby"
  },
  ["nvim-dap-ui"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-nio"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/nvim-nio",
    url = "https://github.com/nvim-neotest/nvim-nio"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["obsidian.nvim"] = {
    config = { "\27LJ\2\n@\0\1\4\0\4\0\a6\1\0\0009\1\1\0019\1\2\0015\3\3\0>\0\2\3B\1\2\1K\0\1\0\1\2\0\0\rxdg-open\rjobstart\afn\bvim�\2\1\0\5\0\t\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\5\0004\3\3\0005\4\3\0>\4\1\0035\4\4\0>\4\2\3=\3\6\0023\3\a\0=\3\b\2B\0\2\1K\0\1\0\20follow_url_func\0\15workspaces\1\0\2\20follow_url_func\0\15workspaces\0\1\0\2\tname\bOld\tpath*/home/mmc/Dropbox/obsidian-vaults/old\1\0\2\tname\fCurrent\tpath./home/mmc/Dropbox/obsidian-vaults/current\nsetup\robsidian\frequire\0" },
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/obsidian.nvim",
    url = "https://github.com/epwalsh/obsidian.nvim"
  },
  ["one-small-step-for-vimkind"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/one-small-step-for-vimkind",
    url = "https://github.com/jbyuki/one-small-step-for-vimkind"
  },
  ["openingh.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/openingh.nvim",
    url = "https://github.com/almo7aya/openingh.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["render-markdown.nvim"] = {
    config = { "\27LJ\2\nw\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\15file_types\1\0\1\15file_types\0\1\3\0\0\rmarkdown\vAvante\nsetup\20render-markdown\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/render-markdown.nvim",
    url = "https://github.com/MeanderingProgrammer/render-markdown.nvim"
  },
  ["telescope-dap.nvim"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-live-grep-args.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/telescope-live-grep-args.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/vim-dadbod",
    url = "https://github.com/tpope/vim-dadbod"
  },
  ["vim-dadbod-ui"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/vim-dadbod-ui",
    url = "https://github.com/kristijanhusak/vim-dadbod-ui",
    wants = { "tpope/vim-dadbod" }
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/vim-markdown",
    url = "https://github.com/tpope/vim-markdown"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["which-key.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/mmc/.local/share/nvim/site/pack/packer/opt/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^dap"] = "nvim-dap"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: obsidian.nvim
time([[Config for obsidian.nvim]], true)
try_loadstring("\27LJ\2\n@\0\1\4\0\4\0\a6\1\0\0009\1\1\0019\1\2\0015\3\3\0>\0\2\3B\1\2\1K\0\1\0\1\2\0\0\rxdg-open\rjobstart\afn\bvim�\2\1\0\5\0\t\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\5\0004\3\3\0005\4\3\0>\4\1\0035\4\4\0>\4\2\3=\3\6\0023\3\a\0=\3\b\2B\0\2\1K\0\1\0\20follow_url_func\0\15workspaces\1\0\2\20follow_url_func\0\15workspaces\0\1\0\2\tname\bOld\tpath*/home/mmc/Dropbox/obsidian-vaults/old\1\0\2\tname\fCurrent\tpath./home/mmc/Dropbox/obsidian-vaults/current\nsetup\robsidian\frequire\0", "config", "obsidian.nvim")
time([[Config for obsidian.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'render-markdown.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType Avante ++once lua require("packer.load")({'render-markdown.nvim'}, { ft = "Avante" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufRead * ++once lua require("packer.load")({'avante.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'which-key.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'nvim-dap'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
