return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  cmd = "Telescope",

  opts = function()
    local conf = require("nvchad.configs.telescope")
    -- Add ui-select extension config
    conf.extensions = conf.extensions or {}
    conf.extensions["ui-select"] = require("telescope.themes").get_dropdown {}
    return conf
  end,

  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("ui-select")
  end,
}
