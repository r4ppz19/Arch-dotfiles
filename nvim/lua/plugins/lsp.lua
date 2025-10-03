return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:nvim-java/mason-registry",
        },
      },
      dependencies = "nvim-telescope/telescope.nvim",
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "html",
          "cssls",
          "cssmodules_ls",
          "css_variables",
          "eslint",
          "vtsls",
          "jsonls",
          "marksman",
          "lua_ls",
          "pyright",
          "bashls",
          "rust_analyzer",
          "emmet_ls",
          "jdtls",
        },
        automatic_enable = false,
      },
    },
    "hrsh7th/cmp-nvim-lsp",
    "nvimdev/lspsaga.nvim",
    "mfussenegger/nvim-jdtls",
  },

  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
      root_markers = { ".git", ".hg", "package.json", "vite.config.js", "vite.config.ts", "tsconfig.json" },
    })

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              -- Neovim runtime
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.env.VIMRUNTIME] = true,
              [vim.fn.stdpath "config"] = true,
              [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
              [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
              ["${3rd}/luv/library"] = true,
            },
            checkThirdParty = false,
            maxPreload = 2000,
            preloadFileSize = 1000,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    vim.lsp.config("vtsls", {
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayTypeParameterHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
          },
          preferences = {
            importModuleSpecifier = "relative",
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayTypeParameterHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
          },
          preferences = {
            importModuleSpecifier = "relative",
          },
        },
      },
    })

    vim.lsp.config("cssmodules_ls", {
      capabilities = capabilities,
      filetypes = { "typescriptreact", "javascriptreact", "tsx", "jsx" },
    })

    vim.lsp.config("cssls", {
      capabilities = capabilities,
      settings = {
        css = { validate = true, lint = { cssConflict = "warning" } },
        scss = { validate = true, lint = { cssConflict = "warning" } },
        less = { validate = true, lint = { cssConflict = "warning" } },
      },
    })

    vim.lsp.config("emmet_ls", {
      capabilities = capabilities,
      filetypes = { "html", "javascriptreact", "typescriptreact", "css", "scss" },
    })

    vim.lsp.config("eslint", {
      capabilities = capabilities,
      settings = {
        format = false,
        codeActionOnSave = {
          enable = true,
          mode = "all",
        },
      },
    })

    local servers = {
      "html",
      "cssls",
      "cssmodules_ls",
      "css_variables",
      "eslint",
      "jsonls",
      "vtsls",
      "marksman",
      "lua_ls",
      "pyright",
      "bashls",
      "rust_analyzer",
      "emmet_ls",
      "jdtls",
    }

    for _, s in ipairs(servers) do
      vim.lsp.enable(s)
    end
  end,
}
