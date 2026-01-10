return {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "biome" },
      html = { "biome" },
      javascript = { "biome" },
      javascriptreact = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      json = { "biome" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      sh = { "shfmt" },
      python = { "black" },
      rust = { "rustfmt" },
    },

    format_after_save = {
      lsp_format = "fallback",
    },
  },
  keys = {
    {
      "<leader>of",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = true,
        })
      end,
      desc = "Format & Autofix File",
    },
  },
}
