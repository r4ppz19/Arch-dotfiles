---@diagnostic disable: undefined-doc-name, undefined-global
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- scroll = {
    --   animate = {
    --     duration = {
    --       step = 10,
    --       total = 200,
    --     },
    --     easing = "outCubic",
    --   },
    -- },
    image = {},

    notifier = {
      enabled = false,
      level = vim.log.levels.TRACE,
      top_down = true,
      margin = { top = 1, right = 1, bottom = 0 },
    },

    picker = {
      enabled = true,
      sources = {
        files = { hidden = true, ignored = false },
        grep = { hidden = true },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<C-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fH",
      function()
        Snacks.picker.files({ dirs = { os.getenv("HOME") } })
      end,
      desc = "Fuzzy Find from Home (Snacks)",
    },

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
        Snacks.picker.help()
      end,
      desc = "Help tags (Snacks)",
    },

    {
      "<leader>fm",
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
  },
}
