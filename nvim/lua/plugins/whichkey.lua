return {
	"folke/which-key.nvim",
	lazy = false,
	opts = function()
		dofile(vim.g.base46_cache .. "whichkey")
		return {}
	end,
}
