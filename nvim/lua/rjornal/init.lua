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

function M.sync_ticket()
  if not is_in_ticket_block() then
    vim.notify("Cursor is not in a ticket block", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand("%:p")
  local cmd = string.format("rjornal sync '%s'", file_path)
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1

  start_loading(buf, line, "Syncing ticket...")

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      vim.schedule(function()
        stop_loading(buf)
        if exit_code == 0 then
          vim.cmd("edit!")
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
  local cmd = string.format("rjornal prompt '%s'", file_path)
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1

  local messages = {
    "Running prompt...",
    "Sending to AI...",
    "Waiting for response...",
    "Processing...",
    "Generating output...",
    "Almost there...",
    "Still working...",
    "Thinking deeply...",
    "Crafting response...",
  }
  local message_index = 1
  local message_timer = nil
  local stdout_lines = {}
  local output_ns = vim.api.nvim_create_namespace("rjornal_output")

  local function update_output()
    vim.api.nvim_buf_clear_namespace(buf, output_ns, 0, -1)
    if #stdout_lines > 0 then
      local virt_lines = {}
      for _, l in ipairs(stdout_lines) do
        table.insert(virt_lines, { { l, "Comment" } })
      end
      vim.api.nvim_buf_set_extmark(buf, output_ns, line, 0, {
        virt_lines = virt_lines,
        virt_lines_above = false,
      })
    end
  end

  -- Start with first message
  start_loading(buf, line, messages[1])

  -- Rotate messages every 3 seconds
  message_timer = vim.loop.new_timer()
  message_timer:start(3000, 3000, vim.schedule_wrap(function()
    message_index = (message_index % #messages) + 1
    -- Update the loading message by restarting with new text
    stop_loading(buf)
    start_loading(buf, line, messages[message_index])
  end))

  vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    on_stdout = function(_, data)
      if data then
        vim.schedule(function()
          for _, l in ipairs(data) do
            if l ~= "" then
              table.insert(stdout_lines, l)
              vim.api.nvim_echo({ { l, "Normal" } }, true, {})
              -- Keep only last 10 lines
              if #stdout_lines > 10 then
                table.remove(stdout_lines, 1)
              end
            end
          end
          update_output()
        end)
      end
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if message_timer then
          message_timer:stop()
          message_timer:close()
        end
        stop_loading(buf)
        vim.api.nvim_buf_clear_namespace(buf, output_ns, 0, -1)
        if exit_code == 0 then
          vim.cmd("edit!")
          vim.notify("Prompt executed successfully", vim.log.levels.INFO)
        else
          vim.notify("Failed to execute prompt", vim.log.levels.ERROR)
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
    end,
  })
end

return M
