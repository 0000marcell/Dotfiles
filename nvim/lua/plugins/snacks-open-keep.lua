local function open_keep(picker, item)
  if not item or not item.file then
    return
  end
  local path = item.file
  if not vim.startswith(path, "/") then
    path = vim.fs.joinpath(picker:cwd(), path)
  end
  local target = picker.main
  if not target or not vim.api.nvim_win_is_valid(target) then
    target = vim.api.nvim_get_current_win()
  end
  vim.api.nvim_win_call(target, function()
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end)
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
