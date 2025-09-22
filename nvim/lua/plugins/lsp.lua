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
				},
			},
		},
		"hrsh7th/cmp-nvim-lsp",
		"nvim-telescope/telescope.nvim",
	},

	config = function()
		-- Set up capabilities for completion
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

		-- Add custom keymaps when LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local tb = require("telescope.builtin")
				local themes = require("telescope.themes")

				-- Custom keymaps (in addition to Neovim 0.11+ defaults)
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

				-- Enable completion if supported
				if client and client.supports_method("textDocument/completion") then
					vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
				end
			end,
		})
	end,
}
