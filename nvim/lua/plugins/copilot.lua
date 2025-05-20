return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    "github/copilot.vim",
    "nvim-lua/plenary.nvim",
  },
  build = "make tiktoken",
  cmd = { "CopilotChatOpen", "CopilotChatToggle" },
  config = function()
    require("CopilotChat").setup(require("configs.copilot"))
  end,
}