return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  cmd = { "CopilotChatOpen", "CopilotChatToggle" },
  config = function()
  require("CopilotChat").setup({
    model = "gpt-4o", -- or "gpt-4", "gpt-3.5-turbo", etc.
    agent = "copilot", -- default agent
    show_help = true,
    prompts = {
    Explain = {
      prompt = "Write an explanation for the selected code as paragraphs of text.",
      system_prompt = "COPILOT_EXPLAIN",
    },
    Review = {
      prompt = "Review the selected code.",
      system_prompt = "COPILOT_REVIEW",
    },
    Fix = {
      prompt = "There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.",
    },
    Tests = {
      prompt = "Please generate tests for my code.",
    },
    },
    window = {
      layout = "vertical", -- "vertical" is a right split, "horizontal" is a bottom split, "float" is floating
      width = 0.4,         -- 40% of the editor width
      height = 1,          -- full height
      border = "single",
      title = "Copilot Chat",
    },
  })
  end,
}
