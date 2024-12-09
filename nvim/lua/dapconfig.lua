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

	-- local whichkey = require "which-key"

  -- local keymap = {
    -- { "<leader>", "<leader>", desc = "<leader>dC", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dj", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>df", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dh", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>de", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>di", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dU", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dk", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dt", nowait = false, remap = false },
    -- { "<leader>", group = "Debug", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>ds", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>da", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dc", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dv", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dw", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>du", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>db", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dx", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>do", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dl", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dd", nowait = false, remap = false },
    -- { "<leader>", "<leader>", desc = "<leader>dr", nowait = false, remap = false },
  -- }

	-- whichkey.register(keymap, {
	-- 	mode = "n",
	-- 	prefix = "<leader>",
	-- 	buffer = nil,
	-- 	silent = true,
	-- 	noremap = true,
	-- 	nowait = false,
	-- })

  -- local keymap_v = {
    -- { "<leader>", group = "Debug", mode = "v", nowait = false, remap = false },
    -- { "<leader>e", "<cmd>lua require'dapui'.eval()<cr>", desc = "Evaluate", mode = "v", nowait = false, remap = false },
  -- }


	-- whichkey.register(keymap_v, {
	-- 	mode = "v",
	-- 	prefix = "<leader>",
	-- 	buffer = nil,
	-- 	silent = true,
	-- 	noremap = true,
	-- 	nowait = false,
	-- })
end

return M
