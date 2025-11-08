return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
  opts = {
    enabled = true,
    debounce = 200,

    indent = {
      char = "│",
      tab_char = "│",
      highlight = "IblChar",
      smart_indent_cap = true,
      priority = 1,
      repeat_linebreak = true,
    },

    scope = {
      enabled = true,
      char = "│",
      show_start = false,
      show_end = false,
      show_exact_scope = false,
      injected_languages = false,
      highlight = "IblScopeChar",
      priority = 1024,
    },

    whitespace = {
      highlight = "IblWhitespace",
      remove_blankline_trail = true,
    },

    exclude = {
      filetypes = {
        "help",
        "terminal",
        "lspinfo",
        "packer",
        "checkhealth",
        "man",
        "gitcommit",
        "TelescopePrompt",
        "TelescopeResults",
        "NvimTree",
        "",
        "copilot-chat",
      },
      buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
    },
  },

  config = function(_, opts)
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
    require("ibl").setup(opts)
  end,
}
