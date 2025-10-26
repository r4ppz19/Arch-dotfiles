return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  build = "make tiktoken || true",
  dependencies = {
    {
      "zbirenbaum/copilot.lua",
      config = function()
        require("copilot").setup {
          suggestion = { enabled = false },
          panel = { enabled = false },
        }
      end,
    },
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
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
      "<M-v>",
      function()
        local chat = require "CopilotChat"
        chat.toggle {
          window = {
            layout = "float",
            width = 120,
            height = 28,
            border = "single",
            title = "",
            zindex = 100,
          },
          auto_fold = true,
        }
      end,
      mode = { "n", "v" },
      desc = "Open copilot in floating window",
    },

    {
      "<leader>cp",
      function()
        local chat = require "CopilotChat"
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
        local chat = require "CopilotChat"
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
        local chat = require "CopilotChat"
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffers\n" }, true)
      end,
      mode = { "n", "v" },
      desc = "Open chat with all buffers",
    },

    -- Pick files with Telescope and feed them as #file: paths
    {
      "<leader>cf",
      function()
        local builtin = require "telescope.builtin"
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"
        local chat = require "CopilotChat"

        builtin.find_files {
          attach_mappings = function(prompt_bufnr, map)
            local run = function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              local multi = picker:get_multi_selection()
              if #multi == 0 then
                local entry = action_state.get_selected_entry()
                multi = { entry }
              end
              local lines = {}
              for _, entry in ipairs(multi) do
                table.insert(lines, "#file:" .. entry.path)
              end
              actions.close(prompt_bufnr)
              chat.open()
              chat.chat:add_message({
                role = "user",
                content = table.concat(lines, "\n") .. "\n\n",
              }, true)
            end

            map("i", "<CR>", run)
            map("n", "<CR>", run)
            return true
          end,
        }
      end,
      desc = "Pick files with Telescope",
    },
  },
}
