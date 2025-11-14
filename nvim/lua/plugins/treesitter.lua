return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup()
    local ensure_installed = {
      "luadoc",
      "printf",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "query",

      "sql",
      "lua",
      "bash",
      "java",
      "rust",
      "python",
      "c",
      "cpp",
      "hyprlang",

      "yaml",
      "toml",
      "xml",
      "json",

      "html",
      "css",
      "javascript",
      "typescript",
      "typescriptreact",
      "javascriptreact",
      "tsx",

      "diff",
      "git_config",
      "gitcommit",
      "git_rebase",
      "gitignore",
      "gitattributes",
    }

    require("nvim-treesitter").install(ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterEnable", { clear = true }),
      pattern = ensure_installed,
      callback = function()
        local bufnr = 0
        pcall(vim.treesitter.start, bufnr)
        if vim.bo[bufnr].indentkeys == "" then
          vim.bo[bufnr].indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
        end
      end,
    })
  end,
}
