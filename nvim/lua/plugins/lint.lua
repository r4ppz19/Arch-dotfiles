return {
  "mfussenegger/nvim-lint",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    vim.env.ESLINT_D_PPID = vim.fn.getpid()
    lint.linters.eslint_d.args = { "--no-warn-ignored" }

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        if lint.linters_by_ft[vim.bo.filetype] then
          lint.try_lint()
        end
      end,
    })
  end,
}
