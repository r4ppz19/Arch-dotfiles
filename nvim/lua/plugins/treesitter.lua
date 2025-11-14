return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  opts = {
    ensure_installed = {
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
    },
  },
  config = function(_, opts)
    require('nvim-treesitter').setup()

    local ensure_installed = opts.ensure_installed
    if ensure_installed and #ensure_installed > 0 then
      require('nvim-treesitter').install(ensure_installed)
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterEnable', { clear = true }),
      pattern = opts.ensure_installed,
      callback = function()
        local bufnr = 0
        pcall(vim.treesitter.start, bufnr)
        if vim.bo[bufnr].indentkeys == '' then
          vim.bo[bufnr].indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
        end
      end,
    })
  end,
}
