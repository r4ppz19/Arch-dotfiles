return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    require("lspsaga").setup {
      lightbulb = {
        enable = false,
      },
      finder = {
        default = "ref+imp+def",
      },
    }

    -- Lspsaga keymaps setup in LspAttach autocmd
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buffer = args.buf
        local map = vim.keymap.set

        map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", {
          buffer = buffer,
          desc = "Go to Definition",
        })
        map("n", "gr", "<cmd>Lspsaga finder<CR>", {
          buffer = buffer,
          desc = "Find References",
        })
        map("n", "gi", "<cmd>Lspsaga finder imp<CR>", {
          buffer = buffer,
          desc = "Go to Implementation",
        })
        map("n", "gy", "<cmd>Lspsaga goto_type_definition<CR>", {
          buffer = buffer,
          desc = "Go to Type Definition",
        })

        map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", {
          buffer = buffer,
          desc = "Peek Definition",
        })
        map("n", "gT", "<cmd>Lspsaga peek_type_definition<CR>", {
          buffer = buffer,
          desc = "Peek Type Definition",
        })

        map({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", {
          buffer = buffer,
          desc = "Code Actions",
        })
        map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", {
          buffer = buffer,
          desc = "Rename Symbol",
        })
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", {
          buffer = buffer,
          desc = "Hover Documentation",
        })
        map("n", "<C-k>", vim.lsp.buf.signature_help, {
          buffer = buffer,
          desc = "Signature Help",
        })

        map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {
          buffer = buffer,
          desc = "Previous Diagnostic",
        })
        map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", {
          buffer = buffer,
          desc = "Next Diagnostic",
        })
        map("n", "<leader>ld", "<cmd>Lspsaga show_buf_diagnostics<CR>", {
          buffer = buffer,
          desc = "Show Line Diagnostics",
        })
        map("n", "<leader>lD", "<cmd>Lspsaga show_workspace_diagnostics<CR>", {
          buffer = buffer,
          desc = "Show Cursor Diagnostics",
        })

        map("n", "<leader>ls", "<cmd>Lspsaga outline<CR>", {
          buffer = buffer,
          desc = "Outline/Symbols Browser",
        })
        map("n", "<leader>li", "<cmd>Lspsaga incoming_calls<CR>", {
          buffer = buffer,
          desc = "Incoming Calls",
        })
        map("n", "<leader>lo", "<cmd>Lspsaga outgoing_calls<CR>", {
          buffer = buffer,
          desc = "Outgoing Calls",
        })

        map("n", "<A-t>", "<cmd>Lspsaga term_toggle<CR>", {
          buffer = buffer,
          desc = "Float Terminal",
        })
      end,
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
