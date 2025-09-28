return {
	"pmizio/typescript-tools.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("typescript-tools").setup({
			capabilities = capabilities,
			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				expose_as_code_action = "all",
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
				tsserver_locale = "en",
				complete_function_calls = false,
			},
		})
	end,
}
