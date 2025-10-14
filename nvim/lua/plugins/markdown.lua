return {

  {
    "iamcco/markdown-preview.nvim",
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>pm",
        "<cmd>MarkdownPreview<cr>",
        desc = "Markdown preview",
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      anti_conceal = { enabled = false },
      -- preset = "none",
      completions = { lsp = { enabled = true } },
    },
    ft = { "markdown", "copilot-chat" },
  },
}
