return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	opts = {
		git = {
			enable = false,
		},
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
	},
}
