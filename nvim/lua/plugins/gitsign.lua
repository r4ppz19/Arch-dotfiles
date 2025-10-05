dofile(vim.g.base46_cache .. "git")

return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  config = function()
    require("gitsigns").setup {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "󱕖" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = { follow_files = true },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      max_file_length = 40000,
      preview_config = { style = "minimal", relative = "cursor", row = 0, col = 1 },
    }
  end,
  keys = {
    -- Navigation
    {
      "]c",
      function()
        require("gitsigns").nav_hunk "next"
      end,
      mode = "n",
      desc = "Next Git Hunk",
    },
    {
      "[c",
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
