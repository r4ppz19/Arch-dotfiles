return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
      },
      delay = 200,
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "terminal",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "copilot-chat",
        "help",
        "man",
        "DiffviewFiles",
        "DiffviewFileHistory",
        "markdown",
        "TelescopePrompt",
        "TelescopeResults",
      },
      min_count_to_highlight = 2,
      under_cursor = true,
    })

    local map = require("utils.map")
    map("n", "[r", function()
      require("illuminate").goto_prev_reference()
    end, { desc = "Prev reference" })
    map("n", "]r", function()
      require("illuminate").goto_next_reference()
    end, { desc = "Next reference" })
  end,
}
