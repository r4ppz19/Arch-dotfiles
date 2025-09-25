return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				registries = {
					"github:mason-org/mason-registry",
					"github:nvim-java/mason-registry",
				},
			},
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
		"nvimdev/lspsaga.nvim",
	},

	config = function()
		-- Set up capabilities for completion
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Global LSP configuration
		vim.lsp.config("*", {
			capabilities = capabilities,
			root_markers = { ".git", ".hg", "package.json", "vite.config.js", "vite.config.ts", "tsconfig.json" },
		})

		-- TypeScript/JavaScript/React specific configuration
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})

		-- CSS/Module CSS configuration
		vim.lsp.config("cssls", {
			capabilities = capabilities,
			settings = {
				css = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				scss = {
					validate = true,
				},
				less = {
					validate = true,
				},
			},
		})

		-- CSS Modules LSP (if you use CSS Modules)
		vim.lsp.config("cssmodules_ls", {
			capabilities = capabilities,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		})

		-- ESLint configuration
		vim.lsp.config("eslint", {
			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"astro",
			},
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = true,
					},
				},
				codeActionOnSave = {
					enable = false,
					mode = "all",
				},
				format = false,
				quiet = false,
				onIgnoredFiles = "off",
				rulesCustomizations = {},
				run = "onType",
				useESLintClass = false,
				validate = "on",
				workingDirectory = {
					mode = "auto",
				},
			},
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

				-- Custom keymaps
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

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
				end
			end,
		})
	end,
}
