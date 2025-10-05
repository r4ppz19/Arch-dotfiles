dofile(vim.g.base46_cache .. "mason")

local servers = {
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
  "lemminx",
  "hyprls",
}

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
        PATH = "skip",
        ui = {
          border = "single",
          icons = {
            package_pending = " ",
            package_installed = " ",
            package_uninstalled = " ",
          },
        },
        max_concurrent_installers = 10,
      },
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
      filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      root_markers = { "package.json", "tsconfig.json", ".git" },
      capabilities = capabilities,
      settings = {
        typescript = {
          suggest = {
            diagnostics = true,
            completeFunctionCalls = true,
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true,
          },
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          format = {
            enable = false,
          },
          preferences = {
            importModuleSpecifier = "relative",
            includePackageJsonAutoImports = "on",
            quotePreference = "auto",
          },
        },
        javascript = {
          suggest = {
            diagnostics = true,
            completeFunctionCalls = true,
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true,
          },
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          format = {
            enable = false,
          },
          preferences = {
            importModuleSpecifier = "relative",
            includePackageJsonAutoImports = "on",
            quotePreference = "auto",
          },
        },
        vtsls = {},
      },
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
      end,
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
        experimental = { useFlatConfig = true },
        format = false,
        codeActionOnSave = {
          mode = "all",
          disableRuleComment = {
            enable = true,
            location = "separateLine",
          },
          showDocumentation = {
            enable = true,
          },
        },
      },
    })

    for _, s in ipairs(servers) do
      vim.lsp.enable(s)
    end
  end,
}
