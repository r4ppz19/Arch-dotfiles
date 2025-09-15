return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	init = function()
		local function get_prettier_cwd(bufnr)
			local util = require("conform.util")

			-- Search for all possible prettier config files
			local root = util.root_file(bufnr, {
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.js",
				".prettierrc.cjs",
				"package.json",
				"prettier.config.js",
				"prettier.config.cjs",
			})

			-- Return directory containing config file if found
			if root and root ~= "" then
				local dir = vim.fn.fnamemodify(root, ":h")
				if dir and dir ~= "" then
					return dir
				end
			end

			-- Fallback to current buffer's directory
			local buf_path = vim.api.nvim_buf_get_name(bufnr)
			if buf_path ~= "" then
				local buf_dir = vim.fn.fnamemodify(buf_path, ":h")
				if buf_dir and buf_dir ~= "" then
					return buf_dir
				end
			end

			-- Absolute fallback to home directory
			return vim.fn.expand("~")
		end

		_G.conform_custom = _G.conform_custom or {}
		_G.conform_custom.prettier_cwd = get_prettier_cwd
	end,
	opts = {
		formatters = {
			prettier = {
				command = "prettier",
				args = {
					"--stdin-filepath",
					"$FILENAME",
				},
				cwd = _G.conform_custom and _G.conform_custom.prettier_cwd,
			},
		},
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
			sh = { "shfmt" },
			python = { "black" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
