return {
  "nvim-tree/nvim-web-devicons",
  opts = function()
    dofile(vim.g.base46_cache .. "devicons")
    return { override = require "nvchad.icons.devicons" }
  end,
}
