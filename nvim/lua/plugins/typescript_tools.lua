return {
  "pmizio/typescript-tools.nvim",
  enabled = true,
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  opts = {
    settings = {
      tsserver_plugins = {
        "typescript-plugin-css-modules",
      },
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      tsserver_max_memory = "auto",
      complete_function_calls = true,
      include_completions_with_insert_text = true,
      disable_member_code_lens = false,
    },
  },

  keys = {
    {
      "<leader>lO",
      "<cmd>TSToolsOrganizeImports<CR>",
      mode = { "n", "v" },
      desc = "TSTools Organize Imports",
    },
  },
}
