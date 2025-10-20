return {
  "folke/trouble.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  cmd = "Trouble",
  opts = {
    auto_close = true,
    focus = true,
    follow = true,
    warn_no_results = false,
    open_no_results = false,
    win = { position = "bottom", type = "split", size = 0.4 },
    preview = {
      type = "main",
      scratch = false,
    },
    modes = {
      lsp_references = {
        params = {
          include_declaration = true,
        },
      },
    },
  },

  keys = {
    { "gr", "<cmd>Trouble lsp toggle<cr>", desc = "LSP References (Trouble)" },
    { "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>lD", "<cmd>Trouble diagnostics toggle workspace=true<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>lf", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    { "<leader>ll", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>lq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    { "<leader>lt", "<cmd>Trouble telescope toggle<cr>", desc = "Telescope Results (Trouble)" },
  },
}
