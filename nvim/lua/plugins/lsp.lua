return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"lua_ls",
					"pyright",
					"bashls",
					"rust_analyzer",
					"html",
					"cssls",
					"emmet_ls",
					"ts_ls",
					"eslint",
					"jsonls",
					"jdtls",
				},
			},
		},
		"hrsh7th/cmp-nvim-lsp",
		"nvim-telescope/telescope.nvim",
	},

	config = function()
		-- Set up capabilities for completion
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Global LSP configuration for all servers
		vim.lsp.config("*", {
			capabilities = capabilities,
			root_markers = { ".git", ".hg", "package.json", "vite.config.js", "vite.config.ts" },
		})

		-- Configure specific servers that need custom settings
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})

		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					cargo = { allFeatures = true },
					check = { command = "clippy" },
				},
			},
		})

		-- Enable all configured LSP servers
		local servers = {
			"lua_ls",
			"pyright",
			"bashls",
			"rust_analyzer",
			"html",
			"cssls",
			"emmet_ls",
			"ts_ls",
			"eslint",
			"jsonls",
			"jdtls",
		}

		for _, server in ipairs(servers) do
			vim.lsp.enable(server)
		end

		-- Add custom keymaps when LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local tb = require("telescope.builtin")
				local themes = require("telescope.themes")

				-- Custom keymaps
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Telescope LSP integration with <leader>l prefix
				map("n", "<leader>ls", tb.lsp_document_symbols, "Document Symbols")
				map("n", "<leader>lS", tb.lsp_workspace_symbols, "Workspace Symbols")
				map("n", "<leader>lr", tb.lsp_references, "LSP References")
				map("n", "<leader>li", tb.lsp_implementations, "LSP Implementations")
				map("n", "<leader>lt", tb.lsp_type_definitions, "Type Definitions")
				map("n", "<leader>lc", tb.lsp_incoming_calls, "Incoming Calls")
				map("n", "<leader>lC", tb.lsp_outgoing_calls, "Outgoing Calls")

				-- Diagnostics with dropdown theme
				map("n", "<leader>ld", function()
					tb.diagnostics(themes.get_dropdown({
						previewer = false,
						layout_config = { width = 0.7, height = 0.7 },
					}))
				end, "Diagnostics")

				-- Buffer-specific diagnostics
				map("n", "<leader>lD", function()
					tb.diagnostics(themes.get_dropdown({
						previewer = false,
						layout_config = { width = 0.7, height = 0.7 },
						bufnr = 0,
					}))
				end, "Buffer Diagnostics")

				-- Additional LSP mappings
				map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
				map("n", "<leader>ln", vim.lsp.buf.rename, "Rename Symbol")
				map("n", "<leader>lh", vim.lsp.buf.signature_help, "Signature Help")
				map("n", "<leader>lf", vim.lsp.buf.format, "Format Buffer")
				map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics to Loclist")

				-- Enhanced navigation (keeping native LSP power)
				map("n", "gd", function()
					vim.lsp.buf.definition({ reuse_win = true })
				end, "Go to Definition")

				map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")

				-- Advanced features if supported
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client then
					-- Document highlighting
					if client:supports_method("textDocument/documentHighlight") then
						map("n", "<leader>lH", vim.lsp.buf.document_highlight, "Highlight References")
						map("n", "<leader>lc", vim.lsp.buf.clear_references, "Clear Highlights")
					end

					-- Inlay hints
					if client:supports_method("textDocument/inlayHint") then
						map("n", "<leader>lI", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "Toggle Inlay Hints")
					end

					-- Code lens
					if client:supports_method("textDocument/codeLens") then
						map("n", "<leader>ll", vim.lsp.codelens.run, "Run Code Lens")
						map("n", "<leader>lL", vim.lsp.codelens.refresh, "Refresh Code Lens")
					end

					-- Semantic tokens
					if client:supports_method("textDocument/semanticTokens/full") then
						map("n", "<leader>lT", function()
							vim.lsp.semantic_tokens.enable(not vim.lsp.semantic_tokens.is_enabled())
						end, "Toggle Semantic Tokens")
					end
				end
			end,
		})
	end,
}
