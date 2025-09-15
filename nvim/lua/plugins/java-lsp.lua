return {
	"nvim-java/nvim-java",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-jdtls",
	},
	config = function()
		require("java").setup({
			extendedClientCapabilities = {
				progressReportProvider = true,
			},
			spring = {
				enabled = true,
			},
		})
	end,
	priority = 1000,
}
