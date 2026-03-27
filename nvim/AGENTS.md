# AGENTS.md - Neovim Configuration Guide

This is a personal Neovim configuration directory. This document provides essential information for agents working in this codebase.

## Project Overview

**Type**: Neovim configuration (Lua-based)  
**Package Manager**: lazy.nvim  
**Primary Languages**: Lua (configuration), with snippets in JSON  
**Purpose**: Personal IDE setup with support for Ruby, Python, JavaScript/TypeScript, Go, Lua, and more

## Directory Structure

```
~/.config/nvim/
├── init.lua                  # Main entry point, bootstraps lazy.nvim and loads plugins
├── lua/mmc/                  # Custom Lua modules and utilities
│   ├── init.lua             # Module loader - calls setup() on custom utilities
│   ├── set.lua              # Vim settings (tabs, numbers, undo, etc.)
│   ├── remap.lua            # Custom keymaps
│   ├── utils.lua            # Helper functions
│   ├── dap/                 # Debug adapter protocol configurations
│   │   ├── init.lua         # DAP setup orchestrator
│   │   ├── keymaps.lua      # Debug keymaps
│   │   ├── go.lua           # Go debugger config
│   │   ├── ruby.lua         # Ruby debugger config
│   │   ├── python.lua       # Python debugger config
│   │   └── lua.lua          # Lua debugger config
│   └── [custom modules]     # Various custom utilities (see below)
├── after/plugin/            # Plugin-specific configurations (loaded after plugins)
├── LuaSnip/                 # Snippet definitions (JSON and Lua)
│   ├── all.lua              # Lua-format snippets for all file types
│   └── [lang]/base.json     # JSON snippets per language
├── snippets/                # Additional snippet definitions
├── testtemplates/           # Test file templates
│   ├── test.rb              # RSpec template
│   └── test.jsx             # Jest/React Testing Library template
└── lazy-lock.json           # Plugin version lockfile
```

## Essential Commands

### Plugin Management
```bash
# From within Neovim
:Lazy                    # Open lazy.nvim UI
:Lazy sync              # Update/install plugins
:Lazy clean             # Remove unused plugins
```

### No Build/Test Commands
This is a configuration directory, not a traditional project. Changes take effect when:
- Restarting Neovim
- Running `:source $MYVIMRC` (mapped to `<leader><leader>`)
- Specific plugin reload commands (see Keymaps section)

## Code Organization

### Module Pattern
All custom Lua modules follow this pattern:
```lua
local M = {}

function M.setup()
  -- Setup code (keymaps, autocmds, etc.)
end

return M
```

Modules are loaded in `lua/mmc/init.lua` by calling their `setup()` function.

### Plugin Configuration Location
- **Plugins declared**: `init.lua` (lazy.nvim spec)
- **Plugin configs**: `after/plugin/[name].lua`
- **Exception**: Some plugins configured inline in `init.lua` using lazy.nvim's `config` function

## Naming Conventions

### Files
- **Snake case**: `createtestfile.lua`, `nvim-lsp.lua`
- **Descriptive names**: Files named after their primary function

### Functions
- **Module functions**: CamelCase (e.g., `M.createtestfile()`, `MMCExecFile()`)
- **Global functions**: PascalCase with MMC prefix (e.g., `MMCUtilsExecAndPrint()`)
- **Local functions**: snake_case (e.g., `configure_debuggers()`)

### Variables
- **Local vars**: snake_case (e.g., `current_buffer`, `file_path`)
- **Module table**: `M` (standard convention)
- **Utility table**: `U` (in utils.lua)

## Key Patterns & Conventions

### 1. Leader Key
- **Leader**: Space (`" "`)
- Most custom commands use `<leader>` prefix

### 2. Indentation & Style
- **2 spaces** for indentation (not tabs)
- `expandtab = true`
- Settings defined in both `init.lua` and `lua/mmc/set.lua`

### 3. Window/Split Navigation
- `<C-h/j/k/l>` for moving between splits
- Vim-style movement prioritized

### 4. File Execution
- `<C-b>` executes current file based on extension:
  - `.rb` → `ruby`
  - `.py` → `python`
  - `.go` → `go run`
  - `.sh` → `bash`
  - `.js` → `node`
- Implementation in `MMCExecFile()` function in `init.lua`

### 5. Snippet System
- **Dual format**: Both JSON (VSCode-style) and Lua (LuaSnip native)
- **JSON location**: `LuaSnip/[language]/base.json`
- **Lua location**: `LuaSnip/all.lua`
- **Backup files**: `.BAK` suffixes indicate previous versions
- **Navigation**: `<Tab>` to expand/jump forward, `<S-Tab>` to jump backward

### 6. Telescope Usage
Telescope is heavily used for file/text search:
- `<leader>ff` - Find files
- `<leader>fs` - Git files
- `<leader>fg` - Live grep (with args)
- `<leader>fr` - Resume last search (important but easily forgotten, per comment)
- `<leader>fb` - Buffers
- `<leader>fh` - Help tags

### 7. LSP Configuration
**Note**: LSP config exists but is **commented out** in `after/plugin/nvim-lsp.lua`.
- Previously configured: flow, solargraph, pyright, lua_ls, ts_ls
- LSP plugins are commented out in lazy.nvim spec
- nvim-cmp and cmp-nvim-lsp are also lazy/commented

## Custom Utilities

### Custom Modules in `lua/mmc/`

| Module | Keymap | Description |
|--------|--------|-------------|
| `createtestfile.lua` | `<leader>ct` | Creates test file from template (JSX → `.test.jsx`, Ruby → `_spec.rb`) |
| `airefactor.lua` | (disabled) | AI-powered refactoring (integrates with external tools) |
| `ripgrepfind.lua` | `<space>ri` | Run custom shell command and select file from results via Telescope |
| `resizepanel.lua` | (setup only) | Panel resizing utilities |
| `currentfileclipboard.lua` | (setup only) | Copy current file path to clipboard |
| `inserttodo.lua` | (setup only) | Insert TODO comments |
| `makeexecutable.lua` | (setup only) | Make current file executable |
| `capitalize.lua` | (setup only) | Text capitalization utilities |
| `replace_with_clipboard.lua` | (setup only) | Replace selection with clipboard |
| `avante_extract_chat_file_paths.lua` | (setup only) | Extract file paths from Avante chat |

### Notable Functions in `init.lua`
- `MMCExecFile()` - Execute current file based on extension
- `MMCUtilsExecAndPrint()` - Run shell command and print output

## Debugging (DAP)

### Supported Languages
- **Go**: via nvim-dap-go
- **Ruby**: via nvim-dap-ruby
- **Python**: via nvim-dap-python (pytest test runner)
- **Lua**: via one-small-step-for-vimkind
- **JavaScript**: Custom pwa-node adapter configuration

### Debug Configuration
- Main config: `lua/dapconfig.lua`
- Per-language: `lua/mmc/dap/[language].lua`
- Keymaps: `lua/mmc/dap/keymaps.lua`
- UI: nvim-dap-ui with custom layout (bottom panel, watches + scopes)
- Virtual text enabled with comments

### DAP UI Behavior
- Opens automatically on debug start
- Closes automatically on debug end/exit
- Log level set to 'TRACE'

## Important Gotchas

### 1. Dual Settings Files
- Settings appear in **both** `init.lua` and `lua/mmc/set.lua`
- `init.lua` takes precedence (loaded last)
- Some duplication exists (e.g., tabstop, expandtab, relativenumber)

### 2. Commented Code
- LSP configuration is fully commented out but preserved
- which-key integration in dapconfig.lua is commented out
- Don't assume LSP is active

### 3. Backup Files
- Many `.BAK` files exist in `LuaSnip/` directories
- These are previous versions, not currently loaded
- Indicates iterative snippet development

### 4. External Dependencies
The config expects these external tools:
- Language servers (if LSP uncommented): flow, solargraph, pyright, lua_ls, ts_ls
- Debuggers: delve (Go), rdbg (Ruby), debugpy (Python)
- Linters (configured but autocmd disabled): flake8, eslint, rubocop
- System tools: xdg-open (Linux URL handler), ripgrep, git
- Custom tools: `refactor`, `kindcoder`, `tscoder` (for airefactor.lua)

### 5. Obsidian Integration
- Obsidian.nvim configured with two workspaces:
  - "Current": `/home/mmc/Obsidian-Vaults/current`
  - "Old": `/home/mmc/Dropbox/obsidian-vaults/old`
- Conceal level set to 1 for Obsidian.nvim compatibility
- Custom markdown syntax highlighting for inline code

### 6. Avante.nvim (AI Assistant)
- Configured with GitHub Copilot provider
- Model: gpt-4o
- Window width: 100
- Requires copilot.lua and related dependencies

### 7. Harpoon v2
- Uses harpoon2 branch
- Custom display shows only filename (not full path)
- Quick navigation: `<leader>1-6` for slots, `<leader>a` to add, `<leader>e` for menu

### 8. Test File Templates
- Templates in `testtemplates/` directory
- Ruby: Basic RSpec structure with `ClassDo` placeholder
- JSX: React Testing Library setup with "Hello World" test
- Created files won't overwrite existing files

### 9. Keymap Conflicts
- `J` in normal mode: remapped to `<C-d>` (scroll down, not typical `mzJ`z`)
- `K` in normal mode: remapped to `<C-b>` (scroll up, conflicts with LSP hover if enabled)
- `K` in visual mode: move selection up

### 10. Lazy Loading
- nvim-dap and dependencies are lazy-loaded on `BufReadPre`
- Avante.nvim loads on `BufRead`
- Most other plugins load immediately

## Keymaps Reference

### Global (Defined in init.lua)
- `<C-c>` (visual) - Copy to system clipboard
- `<C-v>` (normal) - Paste from system clipboard
- `<C-h/j/k/l>` - Navigate splits
- `<C-n>` - Toggle NERDTree
- `<C-b>` - Execute current file
- `<Tab>` (visual) - Indent
- `<S-Tab>` (visual) - Dedent
- `J` (normal) - Scroll down (C-d)
- `K` (normal) - Scroll up (C-b) / (commented) Move selection up
- Space - Leader key

### Leader Mappings (lua/mmc/remap.lua)
- `<leader>pv` - Open netrw
- `<leader>r` (visual) - Execute selected Ruby code
- `<leader>p` (visual) - Execute selected Python code
- `<leader>ti` - Show test info
- `<leader>o` - Open project
- `<leader>i` - Open current file's project
- `<leader><leader>` - Reload init.lua
- `J` (visual) - Move selection down
- `K` (visual) - Move selection up

### CTags Navigation (lua/mmc/remap.lua)
- `gt` - Jump to tag under cursor (was Ctrl-])
- `gs` - Show tag list if multiple matches (was g Ctrl-])
- `gb` - Jump back to previous location (was Ctrl-t)

### Telescope (after/plugin/telescope.lua)
- `<leader>ff` - Find files
- `<leader>fs` - Git files
- `<leader>fr` - Resume last search
- `<leader>fg` - Live grep with args
- `<leader>fb` - Buffers
- `<leader>fh` - Help tags

### Harpoon (after/plugin/harpoon.lua)
- `<leader>a` - Add file to harpoon
- `<leader>e` - Toggle harpoon menu
- `<leader>1-6` - Jump to harpoon slot

### LuaSnip (after/plugin/luasnip.lua)
- `<Tab>` (insert/select) - Expand snippet or jump forward
- `<S-Tab>` (insert/select) - Jump backward
- `<leader><leader>s` - Reload LuaSnip config

### Custom Utilities
- `<leader>ct` - Create test file from template
- `<space>ri` - Ripgrep find (custom command picker)

## AI/Copilot Integration

### GitHub Copilot
- Plugin path: `pack/github/start/copilot.vim/`
- Also uses copilot.lua (for Avante integration)

### Avante.nvim
- AI chat interface in Neovim
- Provider: GitHub Copilot (gpt-4o)
- Custom utility to extract file paths from chat: `avante_extract_chat_file_paths.lua`

## File Type Specific

### Markdown
- Custom syntax highlighting for inline code: `syn match htmlBoldUnderline /\`.*[^\`]*\`/`
- Markdown preview available (iamcco/markdown-preview.nvim)
- Obsidian integration for note-taking

### Database (Dadbod)
- vim-dadbod and vim-dadbod-ui installed
- Query save location: `~/Dropbox/db_ui_queries`

### Git
- vim-fugitive installed
- openingh.nvim for opening files in GitHub

## Development Workflow

### Making Changes
1. Edit relevant Lua file
2. Source init.lua: `<leader><leader>` or restart Neovim
3. For plugin changes, run `:Lazy sync`
4. For snippet changes, reload LuaSnip: `<leader><leader>s`

### Adding New Plugins
1. Add to lazy.nvim spec in `init.lua`
2. Create config file in `after/plugin/[name].lua` if needed
3. Run `:Lazy install`

### Adding Custom Utilities
1. Create `lua/mmc/[name].lua` following module pattern
2. Implement `M.setup()` function
3. Add `require("mmc.[name]").setup()` to `lua/mmc/init.lua`

### Adding Snippets
**JSON format** (VSCode-style):
1. Add to `LuaSnip/[language]/base.json`
2. Reload LuaSnip: `<leader><leader>s`

**Lua format** (native):
1. Add to `LuaSnip/all.lua` or create language-specific file
2. Reload LuaSnip: `<leader><leader>s`

## Color Scheme
- **Theme**: tokyonight.nvim
- **Variant**: storm
- **Transparent background**: enabled
- **Customizations**: italic comments, bold functions

## Search/Ignore Patterns
- Telescope ignores: `node_modules`
- Layout strategy: vertical
- Sorting strategy: ascending

## Things NOT to Do

1. **Don't enable LSP** without confirming with user - it's intentionally disabled
2. **Don't modify `lazy-lock.json`** manually - managed by lazy.nvim
3. **Don't delete `.BAK` files** without checking - they may be intentional backups
4. **Don't assume standard keybinds** - J/K are heavily customized
5. **Don't add tabs** - this config uses 2 spaces consistently
6. **Don't expect tests** - this is a config, not tested software
7. **Don't modify external tool commands** in airefactor.lua without confirming tools exist

## Version/Compatibility Notes
- Neovim version: Not specified in config (assumes recent stable)
- Telescope: pinned to tag 0.1.2
- Harpoon: using harpoon2 branch
- lazy.nvim: stable branch
- Lua 5.1/LuaJIT (Neovim's embedded Lua)
