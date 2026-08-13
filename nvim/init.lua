-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

function my_func()
  vim.api.nvim_command("e /home/mmc/tmp2.md")
end
