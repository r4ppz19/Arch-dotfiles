return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"mason-org/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"nvim-telescope/telescope.nvim",
	},

	config = function()
		require("mason").setup({
			ui = {
				border = "single",
				width = 0.8,
				height = 0.8,
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
				"bashls",
				"rust_analyzer",
				"systemd_ls",
				"html",
				"cssls",
				"emmet_ls",
				"ts_ls",
				"eslint",
			},
			automatic_installation = true,
		})

		local function on_attach(_, bufnr)
			local map = vim.keymap.set
			local tb = require("telescope.builtin")

			-- Use Telescope LSP pickers
			map("n", "gd", tb.lsp_definitions, { buffer = bufnr, desc = "Goto Definition" })
			map("n", "gi", tb.lsp_implementations, { buffer = bufnr, desc = "Goto Implementation" })
			map("n", "gt", tb.lsp_type_definitions, { buffer = bufnr, desc = "Goto Type Definition" })
			map("n", "<leader>lr", tb.lsp_references, { buffer = bufnr, desc = "LSP References" })

			map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Doc" })
			map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })

			-- LSP functions
			map("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("n", "<leader>ln", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
			map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics: Set Loclist" })
			map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
			map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })

			-- Telescope LSP pickers
			map("n", "<leader>ls", tb.lsp_document_symbols, { buffer = bufnr, desc = "LSP Document Symbols" })
			map("n", "<leader>lS", tb.lsp_workspace_symbols, { buffer = bufnr, desc = "LSP Workspace Symbols" })
			map("n", "<leader>ld", tb.diagnostics, { buffer = bufnr, desc = "Diagnostics" })
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("lua_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
					diagnostics = { globals = { "vim" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})
		vim.lsp.config("rust_analyzer", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					inlayHints = {
						bindingModeHints = false,
						typeHints = false,
						parameterHints = false,
						chainingHints = false,
					},
					cargo = { allFeatures = true },
					check = { command = "clippy" },
				},
			},
		})
		vim.lsp.config("ts_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			root_dir = vim.fs.dirname(vim.fs.find({ "package.json", "tsconfig.json" }, { upward = true })[1]),
		})
		vim.lsp.config("emmet_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"html",
				"css",
				"scss",
				"javascriptreact",
				"typescriptreact",
			},
		})
		vim.lsp.config("eslint", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.config("cssls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "css" },
		})
		vim.lsp.config("bashls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.config("html", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.config("systemd_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.config("pyright", {
			on_attach = on_attach,
			capabilities = capabilities,
		})

		vim.lsp.enable("emmet_ls")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("rust_analyzer")
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("eslint")
		vim.lsp.enable("cssls")
		vim.lsp.enable("bashls")
		vim.lsp.enable("html")
		vim.lsp.enable("systemd_ls")
		vim.lsp.enable("pyright")
	end,
}
