return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "󱕖" },
      untracked = { text = "┆" },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,      -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,     -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false,  -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = false,
    current_line_blame = false, -- Disable by default for performance
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil, -- Use default
    max_file_length = 10000, -- Disable gitsigns on files with more than 10000 lines
    preview_config = {
      -- Options passed to nvim_open_win
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },
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
