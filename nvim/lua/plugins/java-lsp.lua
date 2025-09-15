return {
	"nvim-java/nvim-java",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-jdtls",
	},
	config = function()
		require("java").setup({})
	end,
	priority = 1000,
}
