return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require("configs.conform"),
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = require("configs.lspconfig")
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Base
        "vim", "lua", "vimdoc",
        -- Web
        "html", "css", "javascript",
        -- Others
        "bash", "markdown", "java",
      },
    },
  },

  -- NvChad Blink
  { import = "nvchad.blink.lazyspec" },
}