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
					"cssmodules_ls",
					"lemminx",
				},
			},
		},
		"hrsh7th/cmp-nvim-lsp",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-jdtls",
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
			"cssmodules_ls",
			"lemminx",
		}

		for _, server in ipairs(servers) do
			vim.lsp.enable(server)
		end

		-- Add custom keymaps when LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local telescope = require("telescope.builtin")
				local themes = require("telescope.themes")

				-- Custom keymaps
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Telescope LSP integration with <leader>l prefix
				map("n", "gd", telescope.lsp_definitions, "Go to Definition (Telescope)")
				map("n", "<leader>ls", telescope.lsp_document_symbols, "Document Symbols")
				map("n", "<leader>lS", telescope.lsp_workspace_symbols, "Workspace Symbols")
				map("n", "<leader>lr", telescope.lsp_references, "LSP References")
				map("n", "<leader>li", telescope.lsp_implementations, "LSP Implementations")
				map("n", "<leader>lt", telescope.lsp_type_definitions, "Type Definitions")
				map("n", "<leader>lc", telescope.lsp_incoming_calls, "Incoming Calls")
				map("n", "<leader>lC", telescope.lsp_outgoing_calls, "Outgoing Calls")

				-- Diagnostics with dropdown theme
				map("n", "<leader>ld", function()
					telescope.diagnostics(themes.get_dropdown({
						previewer = false,
						layout_config = { width = 0.7, height = 0.7 },
					}))
				end, "Diagnostics")

				-- Buffer-specific diagnostics
				map("n", "<leader>lD", function()
					telescope.diagnostics(themes.get_dropdown({
						previewer = false,
						layout_config = { width = 0.7, height = 0.7 },
						bufnr = 0,
					}))
				end, "Buffer Diagnostics")

				-- Additional LSP mappings
				map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
				map("n", "<leader>ln", vim.lsp.buf.rename, "Rename Symbol")
				map("n", "<leader>lh", vim.lsp.buf.signature_help, "Signature Help")
				map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics to Loclist")

				-- Advanced features if supported
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client then
					-- Java-specific keymaps (nvim-jdtls)
					if client.name == "jdtls" then
						local jdtls = require("jdtls")
						map("n", "<leader>jo", jdtls.organize_imports, "Java: Organize Imports")
						map("n", "<leader>jv", jdtls.extract_variable, "Java: Extract Variable")
						map("v", "<leader>jv", function()
							jdtls.extract_variable(true)
						end, "Java: Extract Variable")
						map("n", "<leader>jc", jdtls.extract_constant, "Java: Extract Constant")
						map("v", "<leader>jc", function()
							jdtls.extract_constant(true)
						end, "Java: Extract Constant")
						map("v", "<leader>jm", function()
							jdtls.extract_method(true)
						end, "Java: Extract Method")
						map("n", "<leader>jcc", function()
							jdtls.compile("full")
						end, "Java: Compile Full")
						map("n", "<leader>jci", function()
							jdtls.compile("incremental")
						end, "Java: Compile Incremental")

						-- Test commands (if nvim-dap is available)
						if pcall(require, "dap") then
							map("n", "<leader>jtc", jdtls.test_class, "Java: Test Class")
							map("n", "<leader>jtm", jdtls.test_nearest_method, "Java: Test Method")
						end
					end
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
				end
			end,
		})
	end,
}
