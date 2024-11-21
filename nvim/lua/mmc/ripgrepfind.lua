local M = {}
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function run_command(command)
  local handle = io.popen(command)
  if not handle then
    return {}
  end

  local result = {}
  for line in handle:lines() do
    table.insert(result, line)
  end

  handle:close()
  return result
end

function M.ripgrepfind()
  -- Prompt user for a command
  vim.ui.input({ prompt = "Enter a shell command to list files: " }, function(input)
    if input and input ~= "" then
      -- Run the user-provided command and capture the output
      local files = run_command(input)

      if #files == 0 then
        vim.notify("No files found or command failed!", vim.log.levels.WARN)
        return
      end

      pickers.new({}, {
        prompt_title = "Command Output Files",
        finder = finders.new_table({
          results = files,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          map('i', '<CR>', function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            local file_path = string.match(selection.value, "^(.-):")
            vim.cmd('edit ' .. file_path)
          end)
          return true
        end,
      }):find()
    else
      vim.notify("No command entered!", vim.log.levels.ERROR)
    end
  end)
end

function M.setup()
  vim.keymap.set('n', '<space>ri', M.ripgrepfind, { noremap = true, silent = true })
end

return M
