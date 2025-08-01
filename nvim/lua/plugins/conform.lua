return {
	-- Formatter
	"stevearc/conform.nvim",
	-- event = "BufWritePre",
	opts = {
		options = {
			formatters_by_ft = {
				lua = { "stylua" },
				css = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				python = { "black" },
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
}
