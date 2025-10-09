return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
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
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      anti_conceal = {
        enabled = false,
        disabled_modes = true,
        render_modes = { "n", "c", "t" },
      },
      completions = { lsp = { enabled = true } },
    },
    ft = { "markdown", "copilot-chat" },
  },
}
