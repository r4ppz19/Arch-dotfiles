return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"mason-org/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"nvim-telescope/telescope.nvim",
		"jinzhongjia/LspUI.nvim",
	},

	config = function()
		require("configs.lspui").setup()

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
			registries = {
				"github:nvim-java/mason-registry",
				"github:mason-org/mason-registry",
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
				"bashls",
				"html",
				"cssls",
				"rust_analyzer",
				"ts_ls",
				"systemd_ls",
				"emmet_ls",
			},
			automatic_installation = true,
		})

		local function on_attach(_, bufnr)
			local map = vim.keymap.set

			-- Use LspUI commands instead of default LSP functions
			map("n", "K", "<cmd>LspUI hover<CR>", { buffer = bufnr, desc = "Hover Doc" })
			map("n", "gd", "<cmd>LspUI definition<CR>", { buffer = bufnr, desc = "Goto Definition" })
			map("n", "gi", "<cmd>LspUI implementation<CR>", { buffer = bufnr, desc = "Goto Implementation" })
			map("n", "gt", "<cmd>LspUI type_definition<CR>", { buffer = bufnr, desc = "Goto Type Definition" })
			map("n", "<leader>lr", "<cmd>LspUI reference<CR>", { buffer = bufnr, desc = "LSP References" })
			map("n", "<leader>la", "<cmd>LspUI code_action<CR>", { buffer = bufnr, desc = "Code Action" })
			map("n", "<leader>lI", "<cmd>LspUI inlay_hint<CR>", { buffer = bufnr, desc = "Toggle Inlay Hints" })
			map(
				"n",
				"<leader>lci",
				"<cmd>LspUI call_hierarchy incoming_calls<CR>",
				{ buffer = bufnr, desc = "Incoming Calls" }
			)
			map(
				"n",
				"<leader>lco",
				"<cmd>LspUI call_hierarchy outgoing_calls<CR>",
				{ buffer = bufnr, desc = "Outgoing Calls" }
			)

			-- Default LSP functions
			map("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("n", "<leader>ln", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
			map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics: Set Loclist" })
			map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
			map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })

			-- Telescope for symbols and diagnostics
			local tb = require("telescope.builtin")
			map("n", "<leader>ls", tb.lsp_document_symbols, { buffer = bufnr, desc = "LSP Document Symbols" })
			map("n", "<leader>lS", tb.lsp_workspace_symbols, { buffer = bufnr, desc = "LSP Workspace Symbols" })
			map("n", "<leader>ld", tb.diagnostics, { buffer = bufnr, desc = "Diagnostics" })
		end

		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.fn.expand("$VIMRUNTIME/lua"),
							vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
							vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
							vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
						},
						maxPreload = 100000,
						preloadFileSize = 10000,
					},
					telemetry = { enable = false },
				},
			},
		})

		lspconfig.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		})

		lspconfig.emmet_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"html",
				"css",
				"scss",
				"javascriptreact",
				"typescriptreact",
				"javascript",
				"typescript",
			},
			init_options = {
				html = {
					options = {
						bem = {
							enabled = true,
						},
					},
				},
			},
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

		lspconfig.systemd_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.cssmodules_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.rust_analyzer.setup({
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
	end,
}
