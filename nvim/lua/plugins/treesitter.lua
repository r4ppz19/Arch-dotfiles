return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = function()
    pcall(function()
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
    end)

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
      },

      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },
    }
  end,
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
