return {
  "folke/trouble.nvim",
  opts = {
    focus = true,
    warn_no_results = false,
    open_no_results = false,
    win = { position = "bottom", type = "split", size = 0.4 },
    modes = {
      lsp_references = {
        params = {
          include_declaration = true,
        },
      },
    },
  },
  cmd = "Trouble",
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
