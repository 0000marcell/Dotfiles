local M = {}

function M.setup()
  print("dap setup!")
  return
	require('dap-go').setup()
  require('dap-ruby').setup()
  require('dap-python').test_runner = 'pytest'
  require('dap-python').setup()
	-- using my configuration
	require("dap").adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {"/home/mmc/vscode-js-debug/js-debug/src/dapDebugServer.js",
			"${port}"},
		}
	}

	require("dap").configurations.javascript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
	}

	require("nvim-dap-virtual-text").setup {
		commented = true,
	}

	local dap, dapui = require "dap", require "dapui"
	dap.set_log_level('TRACE')

	dapui.setup {
		icons = {},
		layouts = {
			{
				elements = {
					{
						id = "watches",
						size = 1
					},
				},
				position = "bottom",
				size = 5
			},
			{
				elements = {
					{
						id = "scopes",
						size = 1
					},
				},
				position = "bottom",
				size = 5
			}
		},
	} -- use default
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	local whichkey = require "which-key"

  local keymap = {
    { "<leader>", "<leader>do", desc = "<cmd>lua require'dap'.step_over()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dd", desc = "<cmd>lua require'dap'.focus_frame()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dc", desc = "<cmd>lua require'dap'.continue()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>db", desc = "<cmd>Telescope dap list_breakpoints<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>da", desc = "<cmd>lua require'dap'.restart()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>de", desc = "<cmd>lua require'dapui'.eval()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dh", desc = "<cmd>lua require'dap.ui.widgets'.hover()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>df", desc = "<cmd>Telescope dap frames<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dj", desc = "<cmd>lua require'dap'.up()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>di", desc = "<cmd>lua require'dap'.step_into()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dk", desc = "<cmd>lua require'dap'.down()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dU", desc = "<cmd>lua require'dapui'.toggle()<cr>", nowait = false, remap = false },
    { "<leader>", group = "Debug", nowait = false, remap = false },
    { "<leader>", "<leader>dt", desc = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>ds", desc = "<cmd>lua require'dap'.continue()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dr", desc = "<cmd>lua require('dapui').float_element('repl', { width = 100, height = 20, enter = true, position = 'center' })<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dC", desc = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>du", desc = "<cmd>lua require'dap'.step_out()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dw", desc = "<cmd>lua require('dapui').float_element('watches', { width = 100, height = 20, enter = true, position = 'bottom' })<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dv", desc = "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dx", desc = "<cmd>lua require'dap'.terminate()<cr>", nowait = false, remap = false },
    { "<leader>", "<leader>dl", desc = "<cmd>lua require'osv'.launch({port = 8086})<cr>", nowait = false, remap = false },
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
    { "<leader>", group = "Debug", mode = "v", nowait = false, remap = false },
    { "<leader>e", "<cmd>lua require'dapui'.eval()<cr>", desc = "Evaluate", mode = "v", nowait = false, remap = false },
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
