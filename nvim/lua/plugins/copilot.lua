return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
	},
	build = "make tiktoken",
	opts = {
		system_prompt = "Your name is Jarvis",
		model = "gpt-4.1",
		temperature = 0.1,
		window = {
			layout = "vertical",
			width = 0.4,
		},
		auto_insert_mode = false,
	},

	keys = {
		{ "<leader>ct", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle CopilotChat" },
		{ "<leader>cr", "<cmd>CopilotChatReset<cr>", mode = "n", desc = "Reset CopilotChat" },
		{ "<leader>cp", "<cmd>CopilotChatPrompts<cr>", mode = "n", desc = "View/select Prompt" },

		{
			"<leader>ci",
			function()
				local chat = require("CopilotChat")
				chat.open()
				chat.chat:add_message({
					role = "user",
					content = "#buffer\n\n"
						.. "Please review this code for idiomatic usage in [language/framework]. "
						.. "Is it written in a way that aligns with common style, conventions, and best practices? "
						.. "If so, point out which parts are idiomatic and why. "
						.. "If not, explain what makes it non-idiomatic and provide concrete suggestions "
						.. "to rewrite it in a more idiomatic way. "
						.. "Include recommendations for readability, maintainability, and adherence to established conventions",
				}, false)
			end,
			mode = { "n", "v" },
			desc = "Check if code is idiomatic",
		},

		{
			"<leader>ca",
			function()
				local chat = require("CopilotChat")
				chat.open()
				chat.chat:add_message({
					role = "user",
					content = "#buffers\n\n",
				}, true)
			end,
			mode = { "n", "v" },
			desc = "Open chat with all buffer",
		},

		{
			"<leader>cc",
			function()
				local chat = require("CopilotChat")
				chat.open()
				chat.chat:add_message({
					role = "user",
					content = "#buffer\n\n",
				}, true)
			end,
			mode = { "n", "v" },
			desc = "Open chat with current buffer",
		},

		{
			"<leader>ce",
			"<cmd>CopilotChatExplain<cr>",
			mode = "v",
			desc = "Explain selected code",
		},
		{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Fix selected code" },
		{
			"<leader>co",
			"<cmd>CopilotChatOptimize<cr>",
			mode = "v",
			desc = "Optimize selected code",
		},
		{ "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "Review selected code" },
		{
			"<leader>cd",
			"<cmd>CopilotChatDocs<cr>",
			mode = "v",
			desc = "Add docs to selected code",
		},
		{
			"<leader>ct",
			"<cmd>CopilotChatTests<cr>",
			mode = "v",
			desc = "Generate tests for selected code",
		},
	},
}
