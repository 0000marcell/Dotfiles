local M = {}

function M.setup()
  -- require("mmc.remap").setup()
  -- require("mmc.set").setup()
  -- require("mmc.openproject")
  -- require("mmc.openprojectfile")
  -- require("mmc.showtestinfo")
  -- require("mmc.execfile")
  require("mmc.avante_extract_chat_file_paths").setup()
  require("mmc.resizepanel").setup()
  require("mmc.currentfileclipboard").setup()
  require("mmc.createtestfile").setup()
  require("mmc.inserttodo").setup()
  require("mmc.makeexecutable").setup()
  require("mmc.capitalize").setup()
  require("mmc.airefactor").setup()
  require("mmc.replace_with_clipboard").setup()
  require("mmc.ripgrepfind").setup()
end

return M
