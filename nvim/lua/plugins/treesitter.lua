return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { "c", "bash", "lua", "vim", "vimdoc", "markdown", "markdown_inline", "java", "css", "html", "javascript" },
      sync_install = false,
      auto_install = true,
  })
  end,
}
