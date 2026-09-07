return {
  dir = "~/.config/nvim/lua/rjornal",
  name = "rjornal",
  ft = "markdown",
  keys = {
    { "<leader>jl", desc = "List unassigned Jira tickets" },
  },
  config = function()
    require("rjornal").setup({
      board_number = 3010,
    })
  end,
}
