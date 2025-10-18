return {
  "RRethy/vim-illuminate",
  event = "BufRead",
  config = function()
    require("illuminate").configure {
      providers = { "lsp", "treesitter", "regex" },
      delay = 50,
      under_cursor = true,

      large_file_cutoff = 5000,
      large_file_overrides = {
        under_cursor = false,
        providers = { "regex" },
        min_count_to_highlight = 2,
      },

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
      },

      modes_denylist = { "i" },
      providers_regex_syntax_denylist = { "Comment", "String", "Constant" },
      min_count_to_highlight = 2,

      disable_keymaps = false,
    }

    local map = require "utils.map"

    map("n", "gn", require("illuminate").goto_next_reference, { desc = "Next Reference" })
    map("n", "gn", require("illuminate").goto_prev_reference, { desc = "Prev Reference" })
    map("o", "ir", require("illuminate").textobj_select, { desc = "Select Reference" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "terminal",
      callback = function()
        require("illuminate").pause_buf()
      end,
    })
  end,
}
