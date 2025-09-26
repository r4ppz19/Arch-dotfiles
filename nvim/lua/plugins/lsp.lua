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
					"marksman",
				},
				automatic_enable = false,
			},
		},
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

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
							vim.fn.stdpath("config"),
						},
						checkThirdParty = false,
						maxPreload = 2000,
						preloadFileSize = 1000,
					},
					telemetry = {
						enable = false,
					},
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
			"marksman",
		}

		for _, server in ipairs(servers) do
			vim.lsp.enable(server)
		end
	end,
}
