return {
  "r4ppz19/r4ppz.nvim",
  lazy = false,
  config = function()
    require("r4ppz").setup({
      color = "#83A598",
      always_show_bufferline = false
    })
  end,
}

