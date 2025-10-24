return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
    { "<leader>dh", "<cmd>DiffviewOpen HEAD<CR>", desc = "Diffview File vs HEAD" },
    { "<leader>dx", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    { "<leader>df", "<cmd>DiffviewToggleFiles<CR>", desc = "Toggle Diffview Files" },
    { "<leader>dl", "<cmd>DiffviewFileHistory %<CR>", desc = "File history (Diffview)" },
  },
  config = function()
    local cb = require("diffview.config").diffview_callback
    require("diffview").setup {
      enhanced_diff_hl = true,
      use_icons = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 30 },
      },
      keymaps = {
        view = {
          ["<tab>"] = cb "select_next_entry",
          ["<s-tab>"] = cb "select_prev_entry",
          ["<leader>e"] = cb "focus_files",
          ["<leader>b"] = cb "toggle_files",
        },
      },
    }
  end,
}
