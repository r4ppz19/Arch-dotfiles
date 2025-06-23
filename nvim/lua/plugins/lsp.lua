return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"mason-org/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
				"ts_ls",
				"bashls",
				"html",
				"cssls",
				"jdtls",
			},
			automatic_installation = true,
		})

		local function on_attach(_, bufnr)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Goto Definition" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: References" })
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP: Goto Type Definition" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Goto Implementation" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Doc" })
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename Symbol" })
			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })
			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { buffer = bufnr, desc = "LSP: Document Symbols" })
			vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP: Show Diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "LSP: Next Diagnostic" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "LSP: Prev Diagnostic" })
		end

		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.bashls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.html.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.cssls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.jdtls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,

}
