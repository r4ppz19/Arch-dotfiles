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
        enable = true,
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

    -- Lspsaga keymaps
    local map = require("utils.map")

    map("n", "gR", "<cmd>Lspsaga finder ref+def+imp<CR>", {
      desc = "Find References (including def and imp)",
    })
    -- map("n", "gr", "<cmd>Lspsaga finder<CR>", {
    --   desc = "Find References",
    -- })
    map("n", "gr", function()
      Snacks.picker.lsp_references({
        auto_confirm = false,
        title = "References",
        layout = {
          preset = "ivy",
        },
      })
    end, { desc = "LSP References (Snacks)" })

    map("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, { desc = "Goto [d]efinition (Snacks)" })

    map("n", "gI", function()
      Snacks.picker.lsp_implementations()
    end, { desc = "Goto [I]mplementation (Snacks)" })

    map("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, { desc = "Goto T[y]pe Definition (Snacks)" })

    map("n", "ge", function()
      Snacks.picker.lsp_declarations()
    end, { desc = "Goto D[e]claration (Snacks)" })

    -- map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", {
    --   desc = "Go to Definition",
    -- })
    -- map("n", "gi", "<cmd>Lspsaga finder imp<CR>", {
    --   desc = "Go to Implementation",
    -- })
    -- map("n", "gy", "<cmd>Lspsaga goto_type_definition<CR>", {
    --   desc = "Go to Type Definition",
    -- })

    map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", {
      desc = "Peek Definition",
    })
    map("n", "gT", "<cmd>Lspsaga peek_type_definition<CR>", {
      desc = "Peek Type Definition",
    })
    map("n", "<S-C-Down>", "<cmd>Lspsaga peek_definition<CR>", {
      desc = "Peek Definition",
    })

    map({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", {
      desc = "Code Actions",
    })

    map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", {
      desc = "Rename Symbol",
    })

    -- map("n", "<S-C-Up>", "<cmd>Lspsaga hover_doc<CR>", {
    --   desc = "Hover Documentation (lspsaga)",
    -- })

    -- map("n", "<S-C-Up>", function()
    --   require("pretty_hover").hover()
    -- end, {
    --   desc = "Hover Documentation (pretty hover)",
    -- })

    -- Diagnostic Show
    map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {
      desc = "Previous Diagnostic",
    })
    map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", {
      desc = "Next Diagnostic",
    })

    map("n", "<leader>lD", "<cmd>Lspsaga show_line_diagnostics<CR>", {
      desc = "Show Line Diagnostics",
    })
    map("n", "<leader>ld", "<cmd>Lspsaga show_buf_diagnostics<CR>", {
      desc = "Show Buffer Diagnostics",
    })
    map("n", "<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", {
      desc = "Show Workspace Diagnostics",
    })

    map("n", "<leader>lS", function()
      Snacks.picker.lsp_symbols()
    end, { desc = "LSP Symbols (Snacks)" })
    map("n", "<leader>ls", "<cmd>Lspsaga outline<CR>", {
      desc = "Outline/Symbols Browser",
    })

    map("n", "<leader>li", "<cmd>Lspsaga incoming_calls<CR>", {
      desc = "Incoming Calls",
    })
    map("n", "<leader>lo", "<cmd>Lspsaga outgoing_calls<CR>", {
      desc = "Outgoing Calls",
    })
  end,
}
