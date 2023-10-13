local M = {}

function M.setup()
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
		d = {
			name = "Debug",
			a = { "<cmd>lua require'dap'.restart()<cr>", "Restart" },
			b = { "<cmd>Telescope dap list_breakpoints<cr>", "Telescope list breakpoints" },
			c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
			C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", 
			"Conditional Breakpoint" },
			d = { "<cmd>lua require'dap'.focus_frame()<cr>", "Focus current frame" },
			e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
			i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
			o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
			j = { "<cmd>lua require'dap'.up()<cr>", "Go up the stack frame" },
			k = { "<cmd>lua require'dap'.down()<cr>", "Go down the stack frame" },
			f = { "<cmd>Telescope dap frames<cr>", "Telescope frames" },
			r = { "<cmd>lua  require('dapui').float_element('repl', { width = 100, height = 20, enter = true, position = 'center' })<cr>", "Toggle Repl" },
			w = { "<cmd>lua  require('dapui').float_element('watches', { width = 100, height = 20, enter = true, position = 'bottom' })<cr>", "Toggle Watch" },
			v = { "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>", "Toggle Repl" },
			s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
			t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
			x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
			u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
			h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
			U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
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
