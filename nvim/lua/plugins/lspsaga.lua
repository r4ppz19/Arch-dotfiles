return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	config = function()
		require("lspsaga").setup({
			lightbulb = {
				enable = false,
				sign = true,
				virtual_text = false,
				debounce = 10,
				sign_priority = 40,
			},
			enable = true,
		})

		-- Lspsaga keymaps setup in LspAttach autocmd
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local keymap = vim.keymap.set

				-- Navigation
				keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { buffer = bufnr, desc = "Go to Definition" })
				keymap("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
				keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { buffer = bufnr, desc = "Find References" })
				keymap("n", "gi", "<cmd>Lspsaga finder imp<CR>", { buffer = bufnr, desc = "Go to Implementation" })
				keymap(
					"n",
					"gy",
					"<cmd>Lspsaga goto_type_definition<CR>",
					{ buffer = bufnr, desc = "Go to Type Definition" }
				)
				keymap(
					"n",
					"<leader>lpd",
					"<cmd>Lspsaga peek_definition<CR>",
					{ buffer = bufnr, desc = "Peek Definition" }
				)
				keymap(
					"n",
					"<leader>lpt",
					"<cmd>Lspsaga peek_type_definition<CR>",
					{ buffer = bufnr, desc = "Peek Type Definition" }
				)

				-- Code Actions
				keymap(
					{ "n", "v" },
					"<leader>la",
					"<cmd>Lspsaga code_action<CR>",
					{ buffer = bufnr, desc = "Code Actions" }
				)
				keymap("n", "<leader>lrn", "<cmd>Lspsaga rename<CR>", { buffer = bufnr, desc = "Rename Symbol" })
				keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { buffer = bufnr, desc = "Hover Documentation" })
				keymap("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })

				-- Diagnostics
				keymap(
					"n",
					"[d",
					"<cmd>Lspsaga diagnostic_jump_prev<CR>",
					{ buffer = bufnr, desc = "Previous Diagnostic" }
				)
				keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { buffer = bufnr, desc = "Next Diagnostic" })
				keymap(
					"n",
					"<leader>ld",
					"<cmd>Lspsaga show_buf_diagnostics<CR>",
					{ buffer = bufnr, desc = "Show Line Diagnostics" }
				)
				keymap(
					"n",
					"<leader>lD",
					"<cmd>Lspsaga show_workspace_diagnostics<CR>",
					{ buffer = bufnr, desc = "Show Cursor Diagnostics" }
				)

				-- LSPSaga Features
				keymap(
					"n",
					"<leader>lo",
					"<cmd>Lspsaga outline<CR>",
					{ buffer = bufnr, desc = "Outline/Symbols Browser" }
				)
				keymap(
					"n",
					"<leader>lci",
					"<cmd>Lspsaga incoming_calls<CR>",
					{ buffer = bufnr, desc = "Incoming Calls" }
				)
				keymap(
					"n",
					"<leader>lco",
					"<cmd>Lspsaga outgoing_calls<CR>",
					{ buffer = bufnr, desc = "Outgoing Calls" }
				)
			end,
		})
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
