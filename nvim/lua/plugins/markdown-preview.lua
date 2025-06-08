return {
  "iamcco/markdown-preview.nvim",

  -- Loading conditions
  ft = { "markdown", "pandoc" },
  lazy = true,

  -- Commands
  cmd = {
    "MarkdownPreviewToggle",
    "MarkdownPreview",
    "MarkdownPreviewStop",
  },

  -- Installation
  build = "cd app && npm install",

  -- Keybindings
  keys = {
    {
      "<leader>cp",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Toggle Markdown Preview",
    },
  },

  -- Plugin configuration
  config = function()
    -- Preview behavior
    vim.g.mkdp_auto_close = false
    vim.g.mkdp_echo_preview_url = true
    vim.g.mkdp_page_title = "${name}"

    -- Network settings
    vim.g.mkdp_open_to_the_world = false
    vim.g.mkdp_open_ip = "127.0.0.1"
    vim.g.mkdp_port = "8888"
    vim.g.mkdp_browser = ""
  end,
}
