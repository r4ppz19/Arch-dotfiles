return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  enabled = true,
  config = function()
    require("illuminate").configure {
      providers = { "lsp" },
      delay = 200, -- Increased delay for better performance
      under_cursor = true,

      filetypes_denylist = {
        "NvimTree",
        "TelescopePrompt",
        "qf",
        "help",
        "man",
        "terminal",
        "dirbuf",
        "fugitive",
        "copilot-chat",
        "css",
        "markdown",
        "txt",
        "text",
      },

      modes_denylist = { "i", "c" }, -- Also disable in command mode
      providers_regex_syntax_denylist = { "Comment", "String", "Constant" },
      min_count_to_highlight = 3, -- Increased to reduce highlighting

      disable_keymaps = false,
    }

    local map = require "utils.map"

    map("n", "]r", require("illuminate").goto_next_reference, { desc = "Next Reference" })
    map("n", "[r", require("illuminate").goto_prev_reference, { desc = "Prev Reference" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "terminal",
      callback = function()
        require("illuminate").pause_buf()
      end,
    })
  end,
}
