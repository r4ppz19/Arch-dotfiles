local M = {}

M.setup = function()
	require("LspUI").setup({
		-- General settings
		prompt = {
			border = true,
			borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},

		-- Code Action configuration
		code_action = {
			enable = true,
			command_enable = true,
			gitsigns = false,
			extend_gitsigns = false,
			ui = {
				title = "Code Action",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},

		-- Hover configuration
		hover = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Hover",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
			},
		},

		-- Rename configuration
		rename = {
			enable = true,
			command_enable = true,
			auto_save = false,
			ui = {
				title = "Rename",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "<C-c>",
				exec = "<CR>",
			},
		},

		-- Diagnostic configuration
		diagnostic = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Diagnostic",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},

		-- Definition configuration
		definition = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Definition",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
				vsplit = "v",
				split = "s",
				tabe = "t",
			},
		},

		-- Reference configuration
		reference = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Reference",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
				vsplit = "v",
				split = "s",
				tabe = "t",
			},
		},

		-- Implementation configuration
		implementation = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Implementation",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
				vsplit = "v",
				split = "s",
				tabe = "t",
			},
		},

		-- Type Definition configuration
		type_definition = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Type Definition",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
				vsplit = "v",
				split = "s",
				tabe = "t",
			},
		},

		-- Declaration configuration
		declaration = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Declaration",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
				vsplit = "v",
				split = "s",
				tabe = "t",
			},
		},

		-- Call Hierarchy configuration
		call_hierarchy = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Call Hierarchy",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
				exec = "<CR>",
				expand = "o",
				jump = "e",
				vsplit = "v",
				split = "s",
				tabe = "t",
			},
		},

		-- Lightbulb configuration
		lightbulb = {
			enable = true,
			command_enable = true,
			icon = "💡",
			action_kind = {
				QuickFix = "🔧",
				Refactor = "♻️",
				RefactorExtract = "📤",
				RefactorInline = "📥",
				RefactorRewrite = "✏️",
				Source = "📄",
				SourceOrganizeImports = "📦",
			},
		},

		-- Inlay Hint configuration
		inlay_hint = {
			enable = true,
			command_enable = true,
		},

		-- Signature Help configuration
		signature = {
			enable = true,
			command_enable = true,
			ui = {
				title = "Signature Help",
				border = "single",
				winblend = 0,
			},
			keys = {
				quit = "q",
			},
		},
	})
end

return M
