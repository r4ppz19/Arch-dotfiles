return {
  "pmizio/typescript-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("typescript-tools").setup {
      capabilities = capabilities,
    }
  end,
}
