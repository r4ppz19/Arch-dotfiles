return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = require("configs.lazygit").commands,
  keys = require("configs.lazygit").mappings,
}