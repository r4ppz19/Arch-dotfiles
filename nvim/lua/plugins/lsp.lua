return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "mason-org/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "nvim-telescope/telescope.nvim",
  },

  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "bashls",
        "html",
        "cssls",
      },
      automatic_installation = true,
    })

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local function on_attach(_, bufnr)
      -- Telescope-based LSP navigation (with fallback)
      vim.keymap.set("n", "gd", function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
          telescope.lsp_definitions()
        else
          vim.lsp.buf.definition()
        end
      end, { buffer = bufnr, desc = "Goto Definition" })

      vim.keymap.set("n", "gi", function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
          telescope.lsp_implementations()
        else
          vim.lsp.buf.implementation()
        end
      end, { buffer = bufnr, desc = "Goto Implementation" })

      vim.keymap.set("n", "gt", function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
          telescope.lsp_type_definitions()
        else
          vim.lsp.buf.type_definition()
        end
      end, { buffer = bufnr, desc = "Goto Type Definition" })

      vim.keymap.set("n", "<leader>lr", function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
          telescope.lsp_references()
        else
          vim.lsp.buf.references()
        end
      end, { buffer = bufnr, desc = "LSP References" })

      vim.keymap.set("n", "<leader>ls", function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
          telescope.lsp_document_symbols()
        else
          vim.lsp.buf.document_symbol()
        end
      end, { buffer = bufnr, desc = "LSP Document Symbols" })

      vim.keymap.set("n", "<leader>lS", function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
          telescope.lsp_workspace_symbols()
        else
          vim.lsp.buf.workspace_symbol()
        end
      end, { buffer = bufnr, desc = "LSP Workspace Symbols" })

      vim.keymap.set("n", "<leader>ld", function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
          telescope.diagnostics()
        else
          vim.diagnostic.open_float()
        end
      end, { buffer = bufnr, desc = "Diagnostics" })

      -- LSP basics
      vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, { buffer = bufnr, desc = "Format File" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Doc" })
      vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
      vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
      vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
      vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
      vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics: Set Loclist" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })
    end

    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.bashls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.html.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.cssls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
}
