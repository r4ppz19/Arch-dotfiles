---@diagnostic disable: undefined-doc-name, undefined-global
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<S-Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<S-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
          },
        },
      },
    },
  },
  keys = {
    {
      "<M-f>",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files (Snacks)",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files (Snacks)",
    },

    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep (Snacks)",
    },

    {
      "<leader>fG",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Buffers (Snacks)",
    },

    {
      "<leader>ft",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo (Snacks)",
    },

    {
      "<leader>fh",
      function()
        Snacks.picker.actions.help()
      end,
      desc = "Help tags (Snacks)",
    },

    {
      "<leader>sm",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages (Snacks)",
    },

    {
      "<leader>bl",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines (Snacks)",
    },

    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers (Snacks)",
    },

    {
      "<M-g>",
      function()
        Snacks.lazygit.open()
      end,
      desc = "Lazygit (Snacks)",
    },
  },
}
