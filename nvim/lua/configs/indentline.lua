return {
  indent = {
    char = "▏",
    tab_char = "│",
    highlight = "IblIndent",
  },
  whitespace = {
    remove_blankline_trail = false,
    highlight = "IblWhitespace",
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
    include = {
      node_type = {
        ["*"] = { "*" },
      },
    },
    highlight = "IblScope",
  },
  exclude = {
    filetypes = {
      "help",
      "terminal",
      "dashboard",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
    },
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
      "prompt",
    },
  },
}
