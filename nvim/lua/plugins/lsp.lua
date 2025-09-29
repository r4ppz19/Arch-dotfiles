return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:nvim-java/mason-registry",
        },
      },
      dependencies = "nvim-telescope/telescope.nvim",
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "html",
          "cssls",
          "cssmodules_ls",
          "css_variables",
          "eslint",
          "jsonls",
          "marksman",
          "lua_ls",
          "pyright",
          "bashls",
          "rust_analyzer",
          "emmet_ls",
          "jdtls",
        },
        automatic_enable = false,
      },
    },

    "hrsh7th/cmp-nvim-lsp",
    "mfussenegger/nvim-jdtls",
    "nvimdev/lspsaga.nvim",
  },

  config = function()
    require("nvchad.configs.lspconfig").defaults()

    local servers = {
      "html",
      "cssls",
      "cssmodules_ls",
      "css_variables",
      "eslint",
      "jsonls",
      "marksman",
      "lua_ls",
      "pyright",
      "bashls",
      "rust_analyzer",
      "emmet_ls",
      "jdtls",
    }
    vim.lsp.enable(servers)

    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.hover, { desc = "LSP Hover" })
  end,
}
