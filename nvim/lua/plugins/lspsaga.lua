---@diagnostic disable: undefined-global
return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.diagnostic.config({
      virtual_text = false,
    })

    require("lspsaga").setup({
      symbol_in_winbar = {
        enable = false,
      },
      outline = {
        win_position = "right",
        win_width = 50,
        max_height = 0.3,
        left_width = 0.3,
        keys = {
          toggle_or_jump = "<CR>",
          jump = "e",
        },
      },
      hover = {
        max_width = 0.5,
      },
      lightbulb = {
        enable = false,
        sign = true,
        virtual_text = false,
        debounce = 10,
        sign_priority = 40,
      },
      ui = {
        code_action = "",
        border = "single",
        title = true,
        expand = "",
        collapse = "",
        actionfix = " ",
        lines = { "", "", "│", "", "" },
        imp_sign = "󰳛 ",
      },
      finder = {
        max_height = 0.5,
        left_width = 0.4,
        right_width = 0.6,
        default = "ref",
        layout = "float",
        silent = true,
        keys = {
          vsplit = "v",
          split = "s",
          toggle_or_open = "<CR>",
          shuttle = "<S-Right>",
          quit = "q",
        },
      },
      definition = {
        keys = {
          edit = "<CR>",
          vsplit = "v",
          split = "s",
        },
      },
      rename = {
        in_select = false,
        quit = "<ESC>",
      },
      diagnostic = {
        extend_relatedInformation = true,
        show_layout = "float",
        max_show_width = 0.5,
        keys = {
          quit = "q",
          quit_in_show = { "q", "<ESC>" },
          toggle_or_jump = "<CR>",
        },
      },
    })
  end,
}
