return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = require("configs.nvim-tree"),
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = require("configs.devicons"),
  },
}