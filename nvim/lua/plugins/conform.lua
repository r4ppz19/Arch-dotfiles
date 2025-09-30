return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters = {
      prettier = {
        command = "prettier",
        prefer_local = "node_modules/.bin",
        args = {
          "--stdin-filepath",
          "$FILENAME",
        },
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      sh = { "shfmt" },
      python = { "black" },
      rust = { "rustfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
  keys = {
    {
      "<leader>pf",
      function()
        require("conform").format { lsp_fallback = true }
      end,
      desc = "Formal File",
    },
  },
}
