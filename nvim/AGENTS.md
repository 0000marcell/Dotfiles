# AGENTS.md

Personal Neovim configuration built on LazyVim (lazy.nvim). This is a dotfiles repo, not a library: there is no build, no test suite, and no CI config in this directory.

## Layout

- `init.lua`: entry point. Adds a `SnacksDashboardOpened` autocmd that opens the file picker on start, then `require("config.lazy")`.
- `lua/config/lazy.lua`: bootstraps lazy.nvim, imports `lazyvim.plugins`, then `{ import = "plugins" }` (every file in `lua/plugins/`). Also calls `config.remote_clipboard`.
- `lua/config/options.lua`, `keymaps.lua`, `autocmds.lua`: standard LazyVim override points, loaded on VeryLazy (options load before lazy.nvim).
- `lua/plugins/*.lua`: one plugin spec per file. Each returns a spec table or list.
- `lua/config/remote_clipboard.lua`: OSC 52 clipboard for tmux/SSH/herdr sessions, with Wayland preferred for paste when available.
- `after/ftplugin/markdown.lua`: markdown-only highlights and virtual labels for ` ```ticket ` and ` ```prompt ` fenced blocks.
- `plugin/after/transparency.lua`: makes UI highlight groups transparent. It is sourced again by the theme hot-reload logic, so it must stay idempotent.
- `pack/github/start/copilot.vim`: a vendored (currently empty) start package.
- `lazy-lock.json`: plugin lock file, managed by lazy.nvim. Do not hand-edit.
- `lazyvim.json`: LazyVim extras list (currently `editor.neo-tree`). Managed by LazyVim.
- `init.lua.BAK`: old backup of the entry file. Not loaded; ignore it.
- `.crush/`: Crush's own runtime state (database, logs). Gitignored and not config.

## Theme

- The active colorscheme is set in `lua/plugins/theme.lua` (currently `matteblack`) via `opts.colorscheme` on the `LazyVim/LazyVim` spec. Change the theme there, not in options.
- `lua/plugins/omarchy-theme-hotreload.lua` listens for the `LazyReload` user event. It re-requires `plugins.theme`, clears highlights, unloads the theme plugin's Lua modules, re-applies the colorscheme, then re-sources `plugin/after/transparency.lua`. If you change theme plumbing, keep these steps in mind: the theme module must be re-requirable and the colorscheme must be read from `opts.colorscheme`.
- `all-themes.lua` and `example.lua` are inactive. `example.lua` begins with `if true then return {} end` and only serves as a reference.

## Plugin specs: conventions and gotchas

- Disabled files: `plugins/example.lua` returns an empty spec on purpose. Leave it alone.
- `plugins/rcg.lua` is conditional. It searches for a local `rcg.nvim` checkout under `~/produce-a-mermaid-graph-visualization-around-a-symbol` or `~/ruby_lsp` (or `$RCG_REPO`). If none exists it returns `{}`, so the plugin silently disappears on other machines.
- `plugins/rjornal.lua` loads a local plugin from `dir = "~/.config/nvim/lua/rjornal"`, which is not part of this repo. It only resolves on machines where that directory exists.
- `plugins/obsidian.lua` is lazy, loaded on `ft = "markdown"`, and sets `conceallevel = 0` for markdown buffers.
- LSP overrides go through `neovim/nvim-lspconfig` `opts.servers`. Example: `herb-lsp.lua` sets `herb_ls` init options. `ruby-lsp.lua` uses `adam12/ruby-lsp.nvim` with rubocop formatting and linting. The commented-out `ruby_lsp` block in that file is an earlier alternative, not active code.
- Treesitter `ensure_installed` is in `plugins/treesitter.lua`. Add parsers there, not in config files.
- `plugins/disable-news-alert.lua` and `snacks-animated-scrolling-off.lua` override LazyVim/snacks opts to turn off news and scroll animation. Extend these files rather than adding new overrides for the same options.
- Plugin specs in `lua/plugins` are imported with `opts` merged into the parent spec, so overriding a LazyVim plugin means returning a spec with the same plugin name plus `opts` (or `opts = function(_, opts)`).

## Options and keymaps

- `options.lua` forces `relativenumber = false`, enables wrap/linebreak/breakindent, and sets Ruby's `indentexpr` to Vim's built-in `GetRubyIndent` instead of treesitter's.
- Netrw is disabled in `autocmds.lua` (`loaded_netrw`, `loaded_netrwPlugin`). Opening a directory on VimEnter instead `cd`s into it, deletes the directory buffer, and opens the Snacks dashboard.
- Custom keymaps in `keymaps.lua`:
  - `<leader>ce`: copy `path:line` to the `+` register.
  - `<leader>go`: open the current file and line on GitHub. It parses `origin` (SSH or HTTPS) and assumes github.com.
  - `<leader>bh` / `<leader>bl`: move the current buffer left or right (bufferline).
  - `<leader>xd`: buffer diagnostics into the location list.
- `:ShowKeymap {lhs}` prints the mapping definition into a temporary split.

## Remote clipboard

`remote_clipboard.setup()` only activates when `TMUX`, `SSH_TTY`/`SSH_CONNECTION`, `HERDR_PANE_ID`, or an ancestor process named `herdr` is present. Otherwise it does nothing. Set `vim.g.omarchy_remote_clipboard_osc52 = false` to skip the OSC 52 copy path. The ancestor lookup reads `/proc`, so it is Linux-specific.

## Style

- `stylua.toml`: 2-space indentation, spaces, column width 120. Format Lua with stylua using this config.
- Some older files (`omarchy-theme-hotreload.lua`, `theme.lua`, `snacks-animated-scrolling-off.lua`, `remote_clipboard.lua`) use tabs. Match the style of the file you are editing rather than reformatting it.
- Keep the user's global rule in mind: do not add explanatory comments to code.

## Verification

There is no test suite or lint script. To check a change:
- Run `nvim --headless "+Lazy! sync" +qa` only if you intend to update plugins (this modifies `lazy-lock.json`).
- Otherwise, open Neovim and check `:messages` and `:checkhealth lazy` for load errors after editing a plugin spec.
- `stylua --check lua` is available if stylua is installed, using `stylua.toml` in this directory.
