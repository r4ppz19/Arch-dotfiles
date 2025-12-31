return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = {
    floating_window_scaling_factor = 0.6,
    yazi_floating_window_border = "single",
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },

  keys = {
    {
      "<leader>y",
      "<cmd>Yazi cwd<cr>",
      desc = "Open Yazi",
    },
    {
      "<leader>e",
      "<cmd>Yazi cwd<cr>",
      desc = "Open Yazi",
    },
  },
}
