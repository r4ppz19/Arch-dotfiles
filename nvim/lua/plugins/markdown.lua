return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    ft = { "markdown" },
    build = "cd app && yarn install",
    keys = {
      {
        "<leader>om",
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
      heading = {
        atx = false,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      },
      bullet = {
        icons = { "-", "-", "-", "-" },
      },
      code = {
        conceal_delimiters = true,
      },
      anti_conceal = {
        enabled = false,
      },
      sign = {
        enabled = false,
      },
    },
    ft = { "copilot-chat", "markdown" },
    keys = {
      {
        "<leader>or",
        function()
          require("render-markdown").toggle()
        end,
        desc = "Toggle render-markdown",
      },
    },
  },
}
