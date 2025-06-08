return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim" },

  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },

  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
  },
}

