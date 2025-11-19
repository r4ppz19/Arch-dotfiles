return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.env.ESLINT_D_PPID = vim.fn.getpid()

    require("lint").linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
      pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
      callback = function()
        require("lint").try_lint("eslint_d")
      end,
    })
  end,
}
