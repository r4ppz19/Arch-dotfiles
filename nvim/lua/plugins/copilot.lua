return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		opts = {
			model = "gpt-4o",
			temperature = 0.1,
			window = {
				layout = "vertical",
				width = 0.4,
			},
			auto_insert_mode = false,
		},
		config = function(_, opts)
			require("CopilotChat").setup(opts)
		end,
		keys = {
			-- Normal mode keybindings
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle CopilotChat" },
			{ "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "Reset CopilotChat" },

			-- Visual mode keybindings - select text and press these keys
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Explain selected code" },
			{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Fix selected code" },
			{ "<leader>co", "<cmd>CopilotChatOptimize<cr>", mode = "v", desc = "Optimize selected code" },
			{ "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "Review selected code" },
			{ "<leader>cd", "<cmd>CopilotChatDocs<cr>", mode = "v", desc = "Add docs to selected code" },
			{ "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = "v", desc = "Generate tests for selected code" },

			{
				"<leader>cc",
				function()
					local select = require("CopilotChat.select")
					require("CopilotChat").open({
						selection = select.visual,
					})
				end,
				mode = "v",
				desc = "Open chat with selected code as context",
			},
		},
	},
}
