return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	build = "make tiktoken",

	config = function()
		require("CopilotChat").setup({
			window = {
				layout = "vertical",
				width = 0.3,
			},
		})
	end,

	cmd = {
		"CopilotChat",
		"CopilotChatOpen",
		"CopilotChatClose",
		"CopilotChatToggle",
		"CopilotChatStop",
		"CopilotChatReset",
		"CopilotChatSave",
		"CopilotChatLoad",
		"CopilotChatPrompts",
		"CopilotChatModels",
		"CopilotChatAgents",
	},
	keys = {
		-- In your plugin config or keymaps.lua
		{ "<leader>ca", "<cmd>CopilotChatAgents<cr>", desc = "Copilot Agents" },
		{ "<leader>cp", "<cmd>CopilotChatPrompts<cr>", desc = "Copilot Prompts" },
		{ "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Copilot Models" },
		{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
	},
}
