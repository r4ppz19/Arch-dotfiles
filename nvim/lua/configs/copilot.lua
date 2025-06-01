return {
  temperature = 0.1,
  chat = {
    keymaps = {
      close = "<C-c>",
      accept = "<C-y>",
      select_next = "<C-n>",
      select_prev = "<C-p>"
    },
    enable_system_commands = false
  },

  picker = {
    telescope = {
      theme = require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
        prompt_title = "Copilot Chat Prompts",
        layout_config = {
          width = 0.6,
          height = 0.6
        },
        border = true,
        borderchars = {
          prompt = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
          results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
          preview = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"}
        }
      })
    }
  },

  window = {
    layout = "vertical",
    relative = "editor",
    width = 0.4,
    height = 1.0,
    border = "rounded",
    title = "Copilot Chat ",
    title_pos = "center",
    position = "right"
  },

  server = {
    handler = "ask",
    prompts = {
      explain = "Explain how this code works in detail:",
      review = "Review this code and suggest improvements:",
      refactor = "Refactor this code to improve its clarity and efficiency:",
      tests = "Generate unit tests for this code:",
      docs = "Write documentation for this code:"
    }
  },

  autocmds = {
    auto_close = false,
    restore_cursor = true
  }
}
