local M = {}

function M.refactor_file()
  -- Get the current file path
  local current_file = vim.fn.expand('%:p')
  local user_text = vim.fn.input('Enter refactor request: ')

  vim.cmd('write')

  local cmd
  local ext = vim.fn.expand('%:e')
  if ext == 'kind2' then
    cmd = 'kindcoder "' .. current_file .. '" "' .. user_text .. '" c'
  elseif ext == 'ts' then
    cmd = 'tscoder "' .. current_file .. '" "' .. user_text .. '" c'
  else
    cmd = 'refactor "' .. current_file .. '" "' .. user_text .. '" c'
  end

  if string.match(user_text, '^%-') or user_text == '' then
    cmd = cmd .. ' --check'
  end

  vim.cmd('!clear && ' .. cmd)

  vim.cmd('edit!')
end

function M.setup()
  -- vim.keymap.set('n', '<space>r', M.refactor_file, { noremap = true, silent = true })
end

return M
