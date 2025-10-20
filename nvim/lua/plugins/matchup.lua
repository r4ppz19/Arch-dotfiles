return {
  "andymass/vim-matchup",
  enabled = true,
  event = { "BufReadPost", "BufWinEnter" },
  config = function()
    vim.g.matchup_matchparen_enabled = 0
    vim.g.matchup_matchparen_deferred = 0

    pcall(function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "html", "javascript", "typescript", "tsx", "xml" },
        highlight = { enable = true },
        matchup = { enable = true },
      }
    end)

    local map = require "utils.map"
    map(
      {
        "n",
        "x",
        "o",
        "v",
      },
      "~",
      "<Plug>(matchup-%)",
      {
        desc = "Jump to matching pair",
      }
    )
  end,
}
