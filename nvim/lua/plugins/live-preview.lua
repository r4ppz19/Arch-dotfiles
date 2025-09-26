return {
	"barrett-ruth/live-server.nvim",
	build = "npm add -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	config = true,
	keys = {
		{ "<leader>pls", "<cmd>LiveServerStart<CR>", desc = "Live Preview Start" },
		{ "<leader>plx", "<cmd>LiveServerStop<CR>", desc = "Live Preview Stop" },
	},
}
