return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  cmd = "WhichKey",
  opts = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>l", group = "LSP", icon = "󰒋" },
      { "<leader>g", group = "Git", icon = "󰊢" },
      { "<leader>c", group = "Copilot", icon = "" },
      { "<leader>f", group = "Picker", icon = "󰭎" },
      { "<leader>v", group = "NvChad", icon = "" },
      { "<leader>o", group = "Others", icon = "󰏖" },
      { "<leader>t", group = "Tabs", icon = "" },
      { "<leader>F", group = "Grep", icon = "󰘳" },
      { "<leader>s", group = "Surround", icon = "" },
      { "<leader>d", group = "Diff", icon = "" },
      { "<leader>b", group = "Buffer", icon = "" },
      { "<leader>u", group = "UI", icon = "󰍹" },

      { "<C-n>", desc = "Toggle NvimTree", icon = "󰙅" },
      { "<leader>e", desc = "Focus NvimTree", icon = "󰉋" },
    })

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

  -- keys = {
  --   { "<leader>ow", "<cmd>WhichKey<CR>", desc = "whichkey all keymaps" },
  -- },
}
