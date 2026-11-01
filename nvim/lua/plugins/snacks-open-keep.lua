local log_file = vim.fn.stdpath("state") .. "/snacks-open-keep.log"

local function log(msg)
  local line = os.date("%H:%M:%S") .. " " .. msg
  vim.fn.writefile({ line }, log_file, "a")
  vim.notify(line, vim.log.levels.INFO, { title = "snacks-open-keep" })
end

local function open_keep(picker, item)
  log("open_keep called, item=" .. vim.inspect(item and item.file))
  if not item or not item.file then
    log("no item file, aborting")
    return
  end
  local path = item.file
  if not vim.startswith(path, "/") then
    path = vim.fs.joinpath(picker:cwd(), path)
  end
  local target = picker.main
  log("main window=" .. tostring(target))
  if not target or not vim.api.nvim_win_is_valid(target) then
    target = vim.api.nvim_get_current_win()
    log("main invalid, using current window=" .. target)
  end
  local ok, err = pcall(vim.api.nvim_win_call, target, function()
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end)
  log("edit ok=" .. tostring(ok) .. " err=" .. tostring(err))
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = {
        open_keep = open_keep,
      },
      win = {
        input = {
          keys = {
            ["<c-o>"] = { "open_keep", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<c-o>"] = { "open_keep", mode = { "n" } },
          },
        },
      },
    },
  },
}
