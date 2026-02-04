return {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "eslint_d", "prettier" },
      javascriptreact = { "eslint_d", "prettier" },
      typescript = { "eslint_d", "prettier" },
      typescriptreact = { "eslint_d", "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      sh = { "shfmt" },
      python = { "black" },
      rust = { "rustfmt" },
    },

    format_after_save = {
      lsp_format = "fallback",
      timeout_ms = 1000,
      async = true,
    },
  },
  keys = {
    {
      "<leader>of",
      function()
        require("conform").format({
          timeout_ms = 1000,
          lsp_fallback = true,
          async = true,
        })
      end,
      desc = "Format & Autofix File",
    },
  },
}
