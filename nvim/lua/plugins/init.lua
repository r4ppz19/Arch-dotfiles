return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = require "configs.lspconfig",
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "bash",
        "markdown",
        "java",
      },
    },
  },

  -- cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opts = function()
      local cmp = require "cmp"
      local conf = require "nvchad.configs.cmp"

      -- Disable automatic completion popup while typing
      conf.completion = {
        autocomplete = false, -- disables automatic popup
      }

      -- Add manual trigger with Alt+Space
      conf.mapping["<M-Space>"] = cmp.mapping.complete()

      return conf
    end,
  },

  -- NvChad Blink
  -- { import = "nvchad.blink.lazyspec" },
}
