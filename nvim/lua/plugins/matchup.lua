return {
  "andymass/vim-matchup",
  enabled = false,
  event = { "BufReadPost", "BufWinEnter" },
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
