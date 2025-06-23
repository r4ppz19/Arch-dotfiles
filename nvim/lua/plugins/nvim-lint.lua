return {
  "mfussenegger/nvim-lint",
  dependencies = {
    "williamboman/mason.nvim",
    "rshkarin/mason-nvim-lint",
  },
  config = function()
    require("mason").setup()
    require("mason-nvim-lint").setup({
      ensure_installed = {
        "flake8",
        "eslint_d",
        "luacheck",
        "shellcheck",
        "htmlhint",
        "stylelint",
      },
      automatic_installation = true,
    })

    local lint = require("lint")
    lint.linters_by_ft = {
      python = { "flake8" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      lua = { "luacheck" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
      html = { "htmlhint" },
      css = { "stylelint" },
      scss = { "stylelint" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    local lint_augroup = vim.api.gvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}


