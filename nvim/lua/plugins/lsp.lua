local servers = {
  "html",
  "cssls",
  "cssmodules_ls",
  "css_variables",
  "eslint",
  "vtsls",
  "jsonls",
  "tailwindcss",
  "marksman",
  "lua_ls",
  "pyright",
  "bashls",
  "rust_analyzer",
  "emmet_ls",
  "lemminx",
  "hyprls",
  "clangd",
  "jdtls",
}

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = function()
        dofile(vim.g.base46_cache .. "mason")
        return {
          PATH = "skip",
          ui = {
            border = "rounded",
            icons = {
              package_pending = " ",
              package_installed = " ",
              package_uninstalled = " ",
            },
          },
          max_concurrent_installers = 10,
        }
      end,
      dependencies = "nvim-telescope/telescope.nvim",
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = servers,
        automatic_enable = false,
      },
    },
    "hrsh7th/cmp-nvim-lsp",
    "nvimdev/lspsaga.nvim",
    "mfussenegger/nvim-jdtls",
  },

  config = function()
    local lsp_config = require "configs.lsp"
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem =
      vim.tbl_deep_extend("force", capabilities.textDocument.completion.completionItem or {}, {
        documentationFormat = {
          "markdown",
          "plaintext",
        },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = {
          valueSet = { 1 },
        },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      })

    -- LSP setup function
    local function setup()
      dofile(vim.g.base46_cache .. "lsp")
      -- require("nvchad.lsp").diagnostic_config()

      -- vim.diagnostic.config {
      --   virtual_text = false,
      --   underline = true,
      --   signs = true,
      --   update_in_insert = false,
      --   severity_sort = true,
      -- }

      -- Default config for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git", ".hg" },
      })

      lsp_config.setup(capabilities)

      -- Enable all listed servers
      for _, s in ipairs(servers) do
        vim.lsp.enable(s)
      end
    end

    -- Run setup
    vim.schedule(setup)
  end,
}
