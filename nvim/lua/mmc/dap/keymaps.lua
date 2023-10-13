local M = {}

local whichkey = require "which-key"

-- local function keymap(lhs, rhs, desc)
--   vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
-- end

function M.setup()
  local keymap = {
    d = {
      name = "Debug",
      a = { "<cmd>lua require'dap'.restart()<cr>", "Restart" },
      R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
      c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
      d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
      C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
      g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
      i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
      o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
      p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
      j = { "<cmd>lua require'dap'.up()<cr>", "Go up the stack frame" },
      k = { "<cmd>lua require'dap'.down()<cr>", "Go down the stack frame" },
      f = { "<cmd>Telescope dap frames<cr>", "Telescope frames" },
      b = { "<cmd>Telescope dap list_breakpoints<cr>", "Telescope list breakpoints" },
      q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
      --r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
      r = { "<cmd>lua  require('dapui').float_element('repl', { width = 100, height = 20, enter = true, position = 'center' })<cr>", "Toggle Repl" },
      v = { "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>", "Toggle Repl" },
      s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
      t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
      x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
      u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },

      h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
      S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },

      U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
      e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
      D = { "<cmd>lua require'osv'.launch({port = 8086})<cr>", "Start Debugging" },
    },
  }

  whichkey.register(keymap, {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
  })

  local keymap_v = {
    name = "Debug",
    e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
  }
  whichkey.register(keymap_v, {
    mode = "v",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
  })
end

return M
