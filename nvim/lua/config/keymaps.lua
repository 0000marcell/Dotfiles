-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Show all diagnostics in location list
vim.keymap.set("n", "<leader>xd", vim.diagnostic.setloclist, { desc = "Buffer diagnostics (loclist)" })

-- Copy current buffer path to clipboard (with line number)
vim.keymap.set("n", "<leader>ce", function()
  local path = vim.fn.expand("%:p") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", path)
  vim.notify("Copied to clipboard: " .. path, vim.log.levels.INFO)
end, { desc = "Copy buffer path to clipboard" })

-- Open current file on GitHub
vim.keymap.set("n", "<leader>go", function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")

  -- Get git root
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    vim.notify("Not a git repository", vim.log.levels.ERROR)
    return
  end

  -- Get relative path from git root
  local rel_path = file:sub(#git_root + 2)

  -- Get current branch
  local branch = vim.fn.systemlist("git -C " .. vim.fn.shellescape(git_root) .. " rev-parse --abbrev-ref HEAD")[1]

  -- Get remote URL
  local remote_url = vim.fn.systemlist("git -C " .. vim.fn.shellescape(git_root) .. " remote get-url origin")[1]
  if vim.v.shell_error ~= 0 then
    vim.notify("No remote 'origin' found", vim.log.levels.ERROR)
    return
  end

  -- Convert SSH/HTTPS URL to GitHub web URL
  local github_url = remote_url
    :gsub("git@github.com:", "https://github.com/")
    :gsub("%.git$", "")

  local url = string.format("%s/blob/%s/%s#L%d", github_url, branch, rel_path, line)
  vim.ui.open(url)
end, { desc = "Open file on GitHub" })
