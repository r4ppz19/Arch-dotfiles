return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  opts = function()
    return {
      ensure_installed = {
        "luadoc",
        "printf",
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "bash",
        "markdown",
        "markdown_inline",
        "java",
        "rust",
        "typescript",
        "tsx",
        "python",
        "yaml",
        "toml",
        "dockerfile",
        "sql",
        "c",
        "cpp",
        "json",
        "xml",
        "hyprlang",
        "query",
      },

      highlight = {
        enable = true,
        disable = { "markdown" },  -- Performance-heavy filetypes
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },
    }
  end,
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
