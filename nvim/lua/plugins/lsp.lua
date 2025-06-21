-- LSP Configuration
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
		},
	},
}
