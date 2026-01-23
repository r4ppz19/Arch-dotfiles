return {
  "Bekaboo/dropbar.nvim",
  event = "BufReadPost",
  opts = {
    bar = {
      truncate = false,
      padding = { left = 2, right = 5 },
      enable = function(buf, win, _)
        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or vim.fn.win_gettype(win) ~= ""
          or vim.bo[buf].buftype ~= ""
          or vim.wo[win].diff
        then
          return false
        end

        local win_config = vim.api.nvim_win_get_config(win)
        if win_config.relative ~= "" or win_config.external then
          return false
        end

        local ignored_filetypes = {
          "gitcommit",
          "diff",
          "Lazy",
          "mason",
          "copilot-chat",
          "snacks_picker_input",
          "snacks_picker_preview",
          "snacks_dashboard",
        }

        if vim.tbl_contains(ignored_filetypes, vim.bo[buf].ft) then
          return false
        end

        -- Only render if there is a source available
        return vim.bo[buf].ft == "markdown"
          or pcall(vim.treesitter.get_parser, buf)
          or not vim.tbl_isempty(vim.lsp.get_clients({
            bufnr = buf,
            method = "textDocument/documentSymbol",
          }))
      end,
    },
    icons = {
      ui = {
        bar = {
          separator = " ",
          extends = "…",
        },
        menu = {
          separator = " ",
          indicator = " ",
        },
      },
    },
  },
  config = function(_, opts)
    require("dropbar").setup(opts)
    local dropbar_api = require("dropbar.api")
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
