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
      selection = "visual",

      temperature = 0.1,
      -- model = "gpt-4.1",
      model = "grok-code-fast-1",
      -- model = "gemini-3-flash-preview",
      -- model = "gpt-5-mini",
      -- model = "gpt-4o",

      window = {
        layout = "vertical",
        width = 0.4,
      },

      headers = {
        user = " r4ppz",
        assistant = "󱚝  Jarvis",
        tool = " Tool",
      },
      separator = "─",
      -- separator = "-",
      highlight_headers = true,

      auto_fold = true,
      show_folds = true,
      auto_insert_mode = false,
      auto_follow_cursor = false,
      insert_at_end = false,
      show_help = false,
      clear_chat_on_new_prompt = false,
      remember_as_sticky = false,
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
        chat.chat:add_message({ role = "user", content = "#buffer:active\n" })
      end,
      mode = { "n", "v" },
      desc = "Open chat with current buffer",
    },

    {
      "<leader>ca",
      function()
        local chat = require("CopilotChat")
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffer:listed\n" })
      end,
      mode = { "n", "v" },
      desc = "Open chat with all buffers",
    },

    {
      "<leader>cf",
      function()
        local snacks = require("snacks")
        snacks.picker.files({
          confirm = function(picker, item)
            local items = picker:selected()
            if #items == 0 then
              items = { item }
            end

            picker:close()

            local lines = {}
            for _, sel in ipairs(items) do
              local path = vim.fn.fnamemodify(sel.file, ":.")
              table.insert(lines, "#file:" .. path)
            end

            local chat = require("CopilotChat")
            chat.open()

            vim.schedule(function()
              vim.api.nvim_put(lines, "l", true, true)
              vim.cmd("normal! G")
            end)
          end,
        })
      end,
      desc = "Add files to CopilotChat",
      mode = { "n", "v" },
    },
  },
}
