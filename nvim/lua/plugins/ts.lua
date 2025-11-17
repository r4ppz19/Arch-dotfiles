return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  opts = {
    settings = {
      jsx_close_tag = { enable = false, filetypes = { "javascriptreact", "typescriptreact" } },
    },
  },
}
