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
      desc = "Find Files (snacks)",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files (snacks)",
    },

    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep (snacks)",
    },

    {
      "<leader>ft",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo (snacks)",
    },

    {
      "<leader>fh",
      function()
        Snacks.picker.actions.help()
      end,
      desc = "Help tags (snacks)",
    },

    {
      "<leader>sm",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages (snacks)",
    },

    {
      "<leader>bl",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines (snacks)",
    },

    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers (snacks)",
    },
  },
}
