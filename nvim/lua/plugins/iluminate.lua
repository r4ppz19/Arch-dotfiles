return {
  "RRethy/vim-illuminate",
  event = "BufRead",
  enabled = true,
  config = function()
    require("illuminate").configure {
      providers = { "lsp", "treesitter" },
      delay = 50,
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
      },

      modes_denylist = { "i" },
      providers_regex_syntax_denylist = { "Comment", "String", "Constant" },
      min_count_to_highlight = 2,

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
