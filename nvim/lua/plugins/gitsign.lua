return {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  opts = function()
    dofile(vim.g.base46_cache .. "git")

    return {
      signs = {
        delete = { text = "󰍵" },
        changedelete = { text = "󱕖" },
      },
    }
  end,
  keys = {
    -- Navigation
    {
      "]h",
      function()
        require("gitsigns").nav_hunk "next"
      end,
      mode = "n",
      desc = "Next Git Hunk",
    },
    {
      "[h",
      function()
        require("gitsigns").nav_hunk "prev"
      end,
      mode = "n",
      desc = "Previous Git Hunk",
    },

    -- Actions
    {
      "<leader>gs",
      function()
        require("gitsigns").stage_hunk()
      end,
      mode = { "n", "v" },
      desc = "Stage Hunk",
    },
    {
      "<leader>gr",
      function()
        require("gitsigns").reset_hunk()
      end,
      mode = { "n", "v" },
      desc = "Reset Hunk",
    },
    {
      "<leader>gS",
      function()
        require("gitsigns").stage_buffer()
      end,
      mode = "n",
      desc = "Stage Buffer",
    },
    {
      "<leader>gR",
      function()
        require("gitsigns").reset_buffer()
      end,
      mode = "n",
      desc = "Reset Buffer",
    },
    {
      "<leader>gp",
      function()
        require("gitsigns").preview_hunk()
      end,
      mode = "n",
      desc = "Preview Hunk",
    },
    {
      "<leader>gi",
      function()
        require("gitsigns").preview_hunk_inline()
      end,
      mode = "n",
      desc = "Preview Hunk Inline",
    },
    {
      "<leader>gb",
      function()
        require("gitsigns").blame_line { full = true }
      end,
      mode = "n",
      desc = "Blame Line",
    },
    {
      "<leader>gd",
      function()
        require("gitsigns").diffthis()
      end,
      mode = "n",
      desc = "Diff Hunk",
    },
    {
      "<leader>gD",
      function()
        require("gitsigns").diffthis "~"
      end,
      mode = "n",
      desc = "Diff With HEAD",
    },
  },
}
