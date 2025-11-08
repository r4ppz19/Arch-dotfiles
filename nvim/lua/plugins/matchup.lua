return {
  "andymass/vim-matchup",
  event = { "BufReadPost", "BufWinEnter" },
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_motion_enabled = 1
    vim.g.matchup_text_obj_enabled = 1

    pcall(function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        matchup = { enable = true },
      })
    end)

    vim.api.nvim_set_hl(0, "MatchParen", {
      fg = "#83A598",
      bg = "#444444",
    })

    vim.api.nvim_set_hl(0, "MatchParenCur", {
      fg = "#83A598",
      bg = "#444444",
    })

    vim.api.nvim_set_hl(0, "MatchWord", {
      fg = "",
      bg = "#444444",
    })

    vim.api.nvim_set_hl(0, "MatchWordCur", {
      fg = "",
      bg = "#444444",
    })

    local map = require("utils.map")
    map({ "n", "x", "o", "v" }, "~", "<Plug>(matchup-%)", { desc = "Jump to matching pair" })
  end,
}
