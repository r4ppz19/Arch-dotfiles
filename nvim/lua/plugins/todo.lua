return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPost",
  opts = function()
    return {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error" },
        TODO = { icon = " ", color = "default" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning" },
        PERF = { icon = " ", color = "hint" },
        NOTE = { icon = " ", color = "info" },
        TEST = { icon = " ", color = "test" },
      },
      gui_style = {
        fg = "NONE",
        bg = "NONE",
        gui = "bold",
      },
      highlight = {
        multiline = false,
      },
      merge_keywords = true,
      colors = {
        error = { "#FB4934" },
        warning = { "#FE8019" },
        info = { "#83A598" },
        hint = { "#8EC07C" },
        default = { "#B8BB26" },
        test = { "#B16286" },
      },
    }
  end,

  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
  },
}
