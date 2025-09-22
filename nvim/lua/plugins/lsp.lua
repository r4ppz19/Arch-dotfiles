return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"williamboman/mason.nvim",
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
				"jsonls",
				"css_variables",
				"cssmodules_ls",
			},
			automatic_installation = true,
		})

		local function on_attach(_, bufnr)
			local map = vim.keymap.set
			local tb = require("telescope.builtin")
			local themes = require("telescope.themes")

			-- LSP API
			map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Goto Definition" })
			map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Goto Implementation" })
			map("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Goto Type Definition" })
			map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Doc" })
			map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
			map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })

			map("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics: Set Loclist" })
			map("n", "<leader>ln", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
			map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })

			-- Telescope API
			map("n", "<leader>ls", tb.lsp_document_symbols, { buffer = bufnr, desc = "LSP Document Symbols" })
			map("n", "<leader>lS", tb.lsp_workspace_symbols, { buffer = bufnr, desc = "LSP Workspace Symbols" })

			map("n", "<leader>ld", function()
				tb.diagnostics(themes.get_dropdown({
					previewer = false,
					layout_config = {
						width = 0.7,
						height = 0.7,
					},
					prompt_title = "Diagnostics",
					include_declaration = true,
				}))
			end, { buffer = bufnr, desc = "Diagnostics" })

			map("n", "<leader>lr", function()
				tb.lsp_references({
					jump_type = "never",
				})
			end, { buffer = bufnr, desc = "LSP References" })
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
			root_dir = function(fname)
				return vim.fs.dirname(
					vim.fs.find({ "package.json", "tsconfig.json" }, { path = fname, upward = true })[1]
				)
			end,
		})

		vim.lsp.config("emmet_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"html",
				"css",
				"scss",
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

		vim.lsp.config("jsonls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "json", "jsonc" },
		})

		vim.lsp.config("css_variables", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "css" },
		})

		vim.lsp.config("cssmodules_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "css" },
		})

		vim.lsp.enable("css_variables")
		vim.lsp.enable("cssmodules_ls")
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
		vim.lsp.enable("jsonls")
	end,
}
