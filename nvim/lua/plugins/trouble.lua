return {
  "folke/trouble.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  cmd = "Trouble",
  opts = {
    auto_close = true,
    focus = true,
    follow = true,
    auto_preview = true,
    warn_no_results = false,
    open_no_results = false,
    win = { position = "bottom", type = "split", size = 0.4 },

    preview = {
      type = "main",
      scratch = true,
    },

    modes = {
      diagnostics = {
        groups = {
          { "filename", format = "{file_icon} {basename:Title} {count}" },
        },
      },

      lsp_references = {
        groups = {
          { "filename", format = "{file_icon} {basename:Title} {count}" },
        },
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.5,
        },
      },
    },

    keys = {
      ["<cr>"] = "jump_close",
      ["p"] = "preview",
      ["P"] = "toggle_preview",
    },
  },

  keys = {
    {
      "gr",
      function()
        require("trouble").open({ mode = "lsp_references" })
      end,
      desc = "LSP References (Trouble)",
    },

    {
      "<leader>ld",
      function()
        require("trouble").toggle("diagnostics")
      end,
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>lD",
      function()
        require("trouble").toggle({
          mode = "diagnostics",
          workspace = true,
        })
      end,
      desc = "Workspace Diagnostics (Trouble)",
    },
    {
      "<leader>lf",
      function()
        require("trouble").toggle("qflist")
      end,
      desc = "Quickfix List (Trouble)",
    },
    {
      "<leader>ll",
      function()
        require("trouble").toggle("loclist")
      end,
      desc = "Location List (Trouble)",
    },
    {
      "<leader>lq",
      function()
        require("trouble").toggle("qflist")
      end,
      desc = "Quickfix (Trouble)",
    },
    {
      "<leader>lt",
      function()
        require("trouble").toggle("telescope")
      end,
      desc = "Telescope Results (Trouble)",
    },
  },
}
