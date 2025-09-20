return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function()
    dofile(vim.g.base46_cache .. "whichkey")
    return {}
  end,
}
