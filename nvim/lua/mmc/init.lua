local M = {}

function M.setup()
  -- require("mmc.remap").setup()
  -- require("mmc.packer").setup()
  -- require("mmc.set").setup()
  -- require("mmc.openproject")
  -- require("mmc.openprojectfile")
  -- require("mmc.showtestinfo")
  -- require("mmc.execfile")
  require("mmc.currentfileclipboard").setup()
  require("mmc.createtestfile").setup()
  require("mmc.inserttodo").setup()
  require("mmc.makeexecutable").setup()
  require("mmc.capitalize").setup()
end

return M
