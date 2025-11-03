local M = {}

function M.currentfileclipboard()
	local current_buffer = vim.api.nvim_get_current_buf()
	local current_file_path = vim.api.nvim_buf_get_name(current_buffer)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local output = vim.fn.system("echo '" .. current_file_path .. ":" .. current_line .. "' | xclip -selection Clipboard")

	print(output)
end

function M.setup()
  vim.keymap.set("n", "<space>cs", require("mmc.currentfileclipboard").currentfileclipboard, { silent = false })
end

return M
