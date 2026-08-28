local M = {}

local function is_in_ticket_block()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local in_ticket = false
  for i, line in ipairs(lines) do
    if line:match("^```ticket") then
      in_ticket = true
    elseif line:match("^```") and in_ticket then
      if cursor_line >= i then
        in_ticket = false
      else
        return true
      end
    end
    if i == cursor_line and in_ticket then
      return true
    end
  end
  return false
end

local function is_in_prompt_block()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local in_prompt = false
  for i, line in ipairs(lines) do
    if line:match("^```prompt") then
      in_prompt = true
    elseif line:match("^```") and in_prompt then
      if cursor_line >= i then
        in_prompt = false
      else
        return true
      end
    end
    if i == cursor_line and in_prompt then
      return true
    end
  end
  return false
end

local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1
local spinner_timer = nil
local loading_ns = vim.api.nvim_create_namespace("rjornal_loading")

local function start_loading(buf, line, message)
  spinner_index = 1
  local function update_spinner()
    vim.api.nvim_buf_clear_namespace(buf, loading_ns, 0, -1)
    local text = string.format(" %s %s ", spinner_frames[spinner_index], message)
    vim.api.nvim_buf_set_extmark(buf, loading_ns, line, 0, {
      virt_text = { { text, "WarningMsg" } },
      virt_text_pos = "eol",
    })
    spinner_index = (spinner_index % #spinner_frames) + 1
  end

  update_spinner()
  spinner_timer = vim.loop.new_timer()
  spinner_timer:start(0, 80, vim.schedule_wrap(update_spinner))
end

local function stop_loading(buf)
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
  vim.api.nvim_buf_clear_namespace(buf, loading_ns, 0, -1)
end

function M.sync_ticket()
  if not is_in_ticket_block() then
    vim.notify("Cursor is not in a ticket block", vim.log.levels.WARN)
    return
  end

  -- Save buffer before syncing to ensure rjornal reads latest content
  vim.cmd("write")

  local file_path = vim.fn.expand("%:p")
  local cmd = string.format("rjornal sync '%s'", file_path)
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local new_file_path = nil

  start_loading(buf, line, "Syncing ticket...")

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      -- CLI outputs the new file path on success
      if data and data[1] and data[1] ~= "" then
        new_file_path = data[1]
      end
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        stop_loading(buf)
        if exit_code == 0 then
          -- Open the new file path (may have been renamed)
          if new_file_path and new_file_path ~= file_path then
            -- Use bwipeout to fully remove the old buffer before opening new one
            vim.cmd("bwipeout")
            vim.cmd("edit " .. vim.fn.fnameescape(new_file_path))
          else
            vim.cmd("edit!")
          end
          vim.notify("Ticket synced successfully", vim.log.levels.INFO)
        else
          vim.notify("Failed to sync ticket", vim.log.levels.ERROR)
        end
      end)
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        vim.schedule(function()
          vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
        end)
      end
    end,
  })
end

function M.open_ticket()
  if not is_in_ticket_block() then
    vim.notify("Cursor is not in a ticket block", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand("%:p")
  local cmd = string.format("rjornal ticket_open '%s'", file_path)
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1

  start_loading(buf, line, "Opening ticket...")

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      vim.schedule(function()
        stop_loading(buf)
        if exit_code == 0 then
          vim.notify("Ticket opened", vim.log.levels.INFO)
        else
          vim.notify("Failed to open ticket", vim.log.levels.ERROR)
        end
      end)
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        vim.schedule(function()
          vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
        end)
      end
    end,
  })
end

function M.run_prompt()
  if not is_in_prompt_block() then
    vim.notify("Cursor is not in a prompt block", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand("%:p")
  local file_dir = vim.fn.fnamemodify(file_path, ":h")
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]

  -- Create prompts directory if it doesn't exist
  local prompts_dir = file_dir .. "/prompts"
  vim.fn.mkdir(prompts_dir, "p")

  -- Generate output file name with date and descriptive name
  local date_str = os.date("%Y-%m-%d")
  local time_str = os.date("%H%M%S")
  local output_file = string.format("%s/prompt-output-%s-%s.md", prompts_dir, date_str, time_str)

  -- Create the output file
  local f = io.open(output_file, "w")
  if f then
    f:close()
  end

  local cmd = string.format("rjornal prompt '%s:%d' '%s'", file_path, line, output_file)
  line = line - 1

  start_loading(buf, line, "Running prompt...")

  -- Open the output file in a new buffer (read-only, auto-reload)
  vim.cmd("vsplit " .. output_file)
  local output_buf = vim.api.nvim_get_current_buf()
  vim.bo[output_buf].readonly = true
  vim.bo[output_buf].modifiable = false

  -- Set up auto-reload for the output buffer
  local reload_timer = vim.loop.new_timer()
  reload_timer:start(200, 200, vim.schedule_wrap(function()
    if vim.api.nvim_buf_is_valid(output_buf) then
      vim.bo[output_buf].readonly = false
      vim.bo[output_buf].modifiable = true
      vim.api.nvim_buf_call(output_buf, function()
        vim.cmd("silent! checktime")
      end)
      vim.bo[output_buf].readonly = true
      vim.bo[output_buf].modifiable = false
    end
  end))

  local stderr_output = {}
  local stdout_output = {}

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      vim.schedule(function()
        reload_timer:stop()
        reload_timer:close()
        stop_loading(buf)
        -- Final reload of output buffer
        if vim.api.nvim_buf_is_valid(output_buf) then
          vim.bo[output_buf].readonly = false
          vim.bo[output_buf].modifiable = true
          vim.api.nvim_buf_call(output_buf, function()
            vim.cmd("silent! edit!")
          end)
          vim.bo[output_buf].readonly = true
          vim.bo[output_buf].modifiable = false
        end
        -- Reload the original note buffer to pick up link changes
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! edit!")
          end)
        end
        if exit_code == 0 then
          local success_msg = "Prompt executed successfully"
          if #stderr_output > 0 then
            success_msg = success_msg .. "\n" .. table.concat(stderr_output, "\n")
          end
          if #stdout_output > 0 then
            success_msg = success_msg .. "\n" .. table.concat(stdout_output, "\n")
          end
          vim.notify(success_msg, vim.log.levels.INFO)
        else
          local error_msg = "Failed to execute prompt (exit code: " .. exit_code .. ")"
          if #stderr_output > 0 then
            error_msg = error_msg .. "\nstderr: " .. table.concat(stderr_output, "\n")
          end
          if #stdout_output > 0 then
            error_msg = error_msg .. "\nstdout: " .. table.concat(stdout_output, "\n")
          end
          vim.notify(error_msg, vim.log.levels.ERROR)
        end
      end)
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stderr_output, line)
          end
        end
      end
    end,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stdout_output, line)
          end
        end
      end
    end,
  })
end

function M.run_code_prompt()
  if not is_in_prompt_block() then
    vim.notify("Cursor is not in a prompt block", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand("%:p")
  local file_dir = vim.fn.fnamemodify(file_path, ":h")
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]

  -- Create prompts directory if it doesn't exist
  local prompts_dir = file_dir .. "/prompts"
  vim.fn.mkdir(prompts_dir, "p")

  -- Generate output file name with date and descriptive name
  local date_str = os.date("%Y-%m-%d")
  local time_str = os.date("%H%M%S")
  local output_file = string.format("%s/code-prompt-output-%s-%s.md", prompts_dir, date_str, time_str)

  -- Create the output file
  local f = io.open(output_file, "w")
  if f then
    f:close()
  end

  local cmd = string.format("rjornal code_prompt '%s:%d' '%s'", file_path, line, output_file)
  line = line - 1

  start_loading(buf, line, "Running code prompt...")

  -- Open the output file in a new buffer (read-only, auto-reload)
  vim.cmd("vsplit " .. output_file)
  local output_buf = vim.api.nvim_get_current_buf()
  vim.bo[output_buf].readonly = true
  vim.bo[output_buf].modifiable = false

  -- Set up auto-reload for the output buffer
  local reload_timer = vim.loop.new_timer()
  reload_timer:start(200, 200, vim.schedule_wrap(function()
    if vim.api.nvim_buf_is_valid(output_buf) then
      vim.bo[output_buf].readonly = false
      vim.bo[output_buf].modifiable = true
      vim.api.nvim_buf_call(output_buf, function()
        vim.cmd("silent! checktime")
      end)
      vim.bo[output_buf].readonly = true
      vim.bo[output_buf].modifiable = false
    end
  end))

  local stderr_output = {}
  local stdout_output = {}

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      vim.schedule(function()
        reload_timer:stop()
        reload_timer:close()
        stop_loading(buf)
        -- Final reload of output buffer
        if vim.api.nvim_buf_is_valid(output_buf) then
          vim.bo[output_buf].readonly = false
          vim.bo[output_buf].modifiable = true
          vim.api.nvim_buf_call(output_buf, function()
            vim.cmd("silent! edit!")
          end)
          vim.bo[output_buf].readonly = true
          vim.bo[output_buf].modifiable = false
        end
        -- Reload the original note buffer to pick up link changes
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! edit!")
          end)
        end
        if exit_code == 0 then
          local success_msg = "Code prompt executed successfully"
          if #stderr_output > 0 then
            success_msg = success_msg .. "\n" .. table.concat(stderr_output, "\n")
          end
          if #stdout_output > 0 then
            success_msg = success_msg .. "\n" .. table.concat(stdout_output, "\n")
          end
          vim.notify(success_msg, vim.log.levels.INFO)
        else
          local error_msg = "Failed to execute code prompt (exit code: " .. exit_code .. ")"
          if #stderr_output > 0 then
            error_msg = error_msg .. "\nstderr: " .. table.concat(stderr_output, "\n")
          end
          if #stdout_output > 0 then
            error_msg = error_msg .. "\nstdout: " .. table.concat(stdout_output, "\n")
          end
          vim.notify(error_msg, vim.log.levels.ERROR)
        end
      end)
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stderr_output, line)
          end
        end
      end
    end,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stdout_output, line)
          end
        end
      end
    end,
  })
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.keymap.set("n", "<leader>jj", M.sync_ticket, {
        buffer = true,
        desc = "Sync ticket with Jira",
      })
      vim.keymap.set("n", "<leader>jo", M.open_ticket, {
        buffer = true,
        desc = "Open ticket in browser",
      })
      vim.keymap.set("n", "<leader>jp", M.run_prompt, {
        buffer = true,
        desc = "Run prompt",
      })
      vim.keymap.set("n", "<leader>jc", M.run_code_prompt, {
        buffer = true,
        desc = "Run code prompt",
      })
    end,
  })
end

return M
