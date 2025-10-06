return {
  {
    "andymass/vim-matchup",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    config = function()
      pcall(function()
        require("nvim-treesitter.configs").setup {
          ensure_installed = { "html", "javascript", "typescript", "tsx", "xml" },
          highlight = { enable = true },
          matchup = { enable = true },
        }
      end)
      vim.keymap.set(
        { "n", "x", "o", "v" },
        "~",
        "<Plug>(matchup-%)",
        { silent = true, desc = "Jump to matching pair" }
      )
    end,
  },
}
