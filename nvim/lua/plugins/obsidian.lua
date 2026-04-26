return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
    { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Tags" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's daily note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's daily note" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links in current note" },
    { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
  },
  opts = {
    workspaces = {
      {
        name = "Main",
        path = "~/Main-01-2026/",
      },
    },
  },
}
