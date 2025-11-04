return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "sindrets/diffview.nvim",
  },
  event = "VeryLazy",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "󱕖" },
      untracked = { text = "┆" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = false,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 200,
    max_file_length = 10000,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },

  config = function(_, opts)
    require("gitsigns").setup(opts)
    local map = require "utils.map"

    -- nvchad terminal lazygit toggle
    map({ "n", "t" }, "<A-g>", function()
      require("nvchad.term").toggle {
        id = "lazygit",
        pos = "float",
        cmd = "lazygit",
        float_opts = {
          relative = "editor",
          row = 0.05,
          col = 0.05,
          width = 0.9,
          height = 0.8,
          border = "single",
        },
      }
    end, { desc = "Toggle LazyGit terminal (Telescope)" })

    -- diff view
    map("n", "<leader>dd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    map("n", "<leader>dx", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    map("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>", { desc = "Open repository history" })
    map("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", { desc = "Open current file history" })

    -- gitsign navigation
    map("n", "]c", function()
      require("gitsigns").nav_hunk "next"
    end, { desc = "Next Git Hunk (GitSign)" })
    map("n", "[c", function()
      require("gitsigns").nav_hunk "prev"
    end, { desc = "Previous Git Hunk (GitSign)" })

    -- stage hunk/buffer
    map("n", "<leader>gs", function()
      require("gitsigns").stage_hunk()
    end, { desc = "Stage Hunk (GitSign)" })
    map("n", "<leader>gS", function()
      require("gitsigns").stage_buffer()
    end, { desc = "Stage Buffer (GitSign)" })

    -- reset hunk/buffer
    map("n", "<leader>gr", function()
      require("gitsigns").reset_hunk()
    end, { desc = "Reset Hunk (GitSign)" })
    map("n", "<leader>gR", function()
      require("gitsigns").reset_buffer()
    end, { desc = "Reset Buffer (GitSign)" })

    -- preview changes/blame
    map("n", "<leader>gp", function()
      require("gitsigns").preview_hunk()
    end, { desc = "Preview Hunk (GitSign)" })
    map("n", "<leader>gP", function()
      require("gitsigns").preview_hunk_inline()
    end, { desc = "Preview Hunk Inline (GitSign)" })
    map("n", "<leader>gb", function()
      require("gitsigns").blame_line { full = true }
    end, { desc = "Blame Line (GitSign)" })

    -- diff hunk/head
    map("n", "<leader>gd", function()
      require("gitsigns").diffthis()
    end, { desc = "Diff Hunk GitSign (GitSign)" })
    map("n", "<leader>gD", function()
      require("gitsigns").diffthis "~"
    end, { desc = "Diff With HEAD (GitSign)" })
  end,
}
