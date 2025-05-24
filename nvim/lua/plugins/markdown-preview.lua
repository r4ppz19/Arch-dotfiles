return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown", "pandoc" }, -- load only for markdown files
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" }, -- commands to trigger plugin
  build = "cd app && npm install", -- build step to install dependencies
  config = function()
    -- Optional configuration
    vim.g.mkdp_auto_close = true -- auto close preview when closing markdown buffer
    vim.g.mkdp_open_to_the_world = false -- restrict preview to localhost only
    vim.g.mkdp_open_ip = "127.0.0.1"
    vim.g.mkdp_port = "8888"
    vim.g.mkdp_browser = "" -- empty means use default browser
    vim.g.mkdp_echo_preview_url = true -- echo preview URL in command line
    vim.g.mkdp_page_title = "${name}" -- page title in preview
  end,
  lazy = true, -- lazy load plugin
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
  },
}
