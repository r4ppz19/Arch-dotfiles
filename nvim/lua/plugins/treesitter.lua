return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "luadoc",
      "printf",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "query",

      "lua",
      "bash",
      "java",
      "rust",
      "python",
      "sql",
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
      "tsx",

      "diff",
      "git_config",
      "gitcommit",
      "git_rebase",
      "gitignore",
      "gitattributes",
    },

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  },
}
