-- Treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"vim",
			"lua",
			"vimdoc",
			"html",
			"css",
			"javascript",
			"bash",
			"markdown",
			"java",
      "rust",
      "typescript",
      "tsx"
		},
	},
}
