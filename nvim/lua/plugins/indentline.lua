return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		whitespace = {
			remove_blankline_trail = false,
			highlight = "IblWhitespace",
		},
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
			include = {
				node_type = {
					["*"] = { "*" },
				},
			},
			highlight = "IblScope",
		},
		exclude = {
			filetypes = {
				"help",
				"terminal",
				"dashboard",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
				"NvimTree",
				"neo-tree",
				"Trouble",
				"alpha",
			},
			buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
			},
		},
	},
}
