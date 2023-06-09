local popup = require("plenary.popup")

local Win_id

function ShowMenu(opts, cb)
  local height = 20
  local width = 30
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  Win_id = popup.create(opts, {
        title = "MyProjects",
        highlight = "MyProjectWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
  })
  local bufnr = vim.api.nvim_win_get_buf(Win_id)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent=false })
end

function OpenProject()
  local file = io.open("/home/mmc/projects", "r") -- Open the file in read mode
  local opts = {}
  if file then
    for line in file:lines() do
      table.insert(opts, line)
    end

    local cb = function(_, sel)
      vim.cmd("cd " .. sel)
    end
    ShowMenu(opts, cb)
    print(opts)
    --local contents = file:read("*a") -- Read the entire contents of the file
    file:close() -- Close the file
  else
    print("Failed to open the file")
  end
end

function CloseMenu()
  vim.api.nvim_win_close(Win_id, true)
end
