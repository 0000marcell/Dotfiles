local M = {}

function M.replace_with_clipboard()
  -- Get the clipboard contents
  local clipboard_content = vim.fn.getreg('+')

  -- Start editing in the current buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(clipboard_content, '\n'))
end


function M.setup()
  vim.keymap.set('n', '<space>cr', M.replace_with_clipboard, { noremap = true, silent = true })
end

return M
