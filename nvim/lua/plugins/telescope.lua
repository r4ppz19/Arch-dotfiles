return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	cmd = "Telescope",

	opts = function()
		local conf = require("nvchad.configs.telescope")

		conf.defaults = vim.tbl_deep_extend("force", conf.defaults or {}, {
			file_ignore_patterns = {
				"node_modules",
				".git/",
				"%.jpg",
				"%.jpeg",
				"%.png",
				"%.webp",
				"%.otf",
				"%.ttf",
				"%.lock",
				"%.zip",
				"%.tar.gz",
				"__pycache__",
				"venv",
				"%.pyc",
			},
		})

		-- ui-select dropdown theme
		conf.extensions = vim.tbl_deep_extend("force", conf.extensions or {}, {
			["ui-select"] = require("telescope.themes").get_dropdown({}),
		})

		return conf
	end,

	config = function(_, opts)
		require("telescope").setup(opts)
		require("telescope").load_extension("ui-select")
	end,
}
