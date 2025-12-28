local M = {}

function M.avante_extract_file_paths_from_text(text)
    local file_paths_table = {}
    for path in text:gmatch("Filepath:%s*([^\n]+)") do
        table.insert(file_paths_table, path)
    end
    local file_paths_text = table.concat(file_paths_table, "\n")
    return file_paths_text
end

-- for debugging purposes
function print_table(t)
    for i, v in ipairs(t) do
        print(i, v)
    end
end

function M.copy_to_clipboard(text)
  local output = vim.fn.system("echo '" .. text .. "' | xclip -selection Clipboard")
	print(output)
end

function M.avante_current_window_text()
    local active_window = vim.api.nvim_get_current_win()
    local buffer = vim.api.nvim_win_get_buf(active_window)
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local window_text = table.concat(lines, "\n")
    return window_text
end

function M.avante_extract_chat_file_paths()
    local window_text = M.avante_current_window_text()
    local file_paths_text = M.avante_extract_file_paths_from_text(window_text)
    M.copy_to_clipboard(file_paths_text)
end

function M.setup()
    vim.keymap.set('n', '<space>f', M.avante_extract_chat_file_paths, { noremap = true, silent = true, desc = "Copy chat file paths to clipboard" })
end

return M
