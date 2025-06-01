return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {"github/copilot.vim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"},
  build = function()
    vim.notify("Please run 'make' in " .. vim.fn.stdpath("data") .. "/lazy/CopilotChat.nvim to install tiktoken")
  end,
  cmd = {"CopilotChatOpen", "CopilotChatToggle", "CopilotChatExplain", "CopilotChatDocs", "CopilotChatModels",
         "CopilotChatAgents"},
  keys = {{
    "<leader>cc",
    "<cmd>CopilotChatToggle<cr>",
    desc = "Toggle Copilot Chat"
  }, {
    "<leader>ce",
    "<cmd>CopilotChatExplain<cr>",
    desc = "Explain Code"
  }, {
    "<leader>cp",
    function()
      local actions = require("CopilotChat.actions")
      require("CopilotChat.integrations.telescope").pick(actions.prompt_actions({
        selection = require("CopilotChat.select").visual
      }))
    end,
    mode = "x",
    desc = "Prompt Actions"
  }},
  config = function()
    require("CopilotChat").setup(require("configs.copilot"))
  end
}
