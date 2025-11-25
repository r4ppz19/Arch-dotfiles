return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  build = "make tiktoken",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  opts = function()
    return {
      system_prompt = require("configs.prompts").system_prompt,
      prompts = require("configs.prompts").prompts,

      resources = "selection",
      temperature = 0.1,
      -- model = "gpt-4.1",
      model = "grok-code-fast-1",
      -- model = "gpt-5-mini",

      window = {
        layout = "vertical",
        width = 0.4,
      },

      headers = {
        user = " r4ppz",
        assistant = "󱚝  Jarvis",
        tool = " Tool",
      },
      -- separator = "─",
      separator = "───",
      highlight_headers = true,

      auto_fold = true,
      show_folds = true,
      auto_insert_mode = false,
      auto_follow_cursor = false,
      show_help = false,
      clear_chat_on_new_prompt = false,
    }
  end,

  keys = {
    { "<leader>ci", "<cmd>CopilotChatIdiomatic<cr>", mode = { "n", "v" }, desc = "Check if code is idiomatic" },
    { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain code" },
    { "<leader>cs", "<cmd>CopilotChatSuggest<cr>", mode = { "n", "v" }, desc = "Suggest alternatives" },
    { "<M-c>", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle CopilotChat" },
    { "<leader>cm", "<cmd>CopilotChatModels<cr>", mode = { "n", "v" }, desc = "View/select available models" },

    {
      "<leader>cp",
      function()
        local chat = require("CopilotChat")
        chat.open()
        chat.select_prompt()
      end,
      mode = { "n", "v" },
      desc = "View/select prompt templates",
    },

    -- Open chat with current buffer
    {
      "<leader>cc",
      function()
        local chat = require("CopilotChat")
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffer\n" }, true)
      end,
      mode = { "n", "v" },
      desc = "Open chat with current buffer",
    },

    -- Open chat with all buffers
    {
      "<leader>ca",
      function()
        local chat = require("CopilotChat")
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffers\n" }, true)
      end,
      mode = { "n", "v" },
      desc = "Open chat with all buffers",
    },
  },
}
