return {
  dir = "~/.config/nvim/lua/rjornal",
  name = "rjornal",
  ft = "markdown",
  config = function()
    require("rjornal").setup()
  end,
}
