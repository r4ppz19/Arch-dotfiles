return {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },

      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      markdown = { "prettierd" },
      yaml = { "prettierd" },

      lua = { "stylua" },
      sh = { "shfmt" },
      python = { "black" },
      rust = { "rustfmt" },
    },

    format_after_save = {
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
          async = true,
        })
      end,
      desc = "Format & Autofix File",
    },
  },
}
