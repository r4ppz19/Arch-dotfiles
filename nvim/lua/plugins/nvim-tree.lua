return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = false,
      },
      actions = {
        open_file = {
          quit_on_open = true, -- Close the tree when opening a file
        },
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },
}
