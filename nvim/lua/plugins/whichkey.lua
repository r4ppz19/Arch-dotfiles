return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  cmd = "WhichKey",
  opts = function()
    local wk = require "which-key"
    wk.add {
      { "<leader>l", group = "LSP", icon = "󰒋" },
      { "<leader>g", group = "Git", icon = "󰊢" },
      { "<leader>c", group = "Copilot", icon = "" },
      { "<leader>f", group = "Telescope", icon = "󰭎" },
      { "<leader>n", group = "NvChad", icon = "" },
      { "<leader>p", group = "Others", icon = "󰏖" },
      { "<leader>w", group = "WhichKey", icon = "󰘳" },
      { "<leader>t", group = "Tabs", icon = "" },
      { "<leader>F", group = "Grep", icon = "󰘳" },
      { "<leader>s", group = "Surround", icon = "" },

      { "<C-n>", desc = "Toggle NvimTree", icon = "󰙅" },
      { "<leader>e", desc = "Focus NvimTree", icon = "󰉋" },
    }

    return {
      icons = {
        group = "",
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
        title = false,
        title_pos = "center",
      },
      layout = {
        width = { min = 25, max = 50 },
        spacing = 4,
        align = "center",
      },
      sort = { "local", "group", "alphanum" },
      show_help = false,
      show_keys = false,
    }
  end,

  keys = {
    { "<leader>pw", "<cmd>WhichKey<CR>", desc = "whichkey all keymaps" },
  },
}
