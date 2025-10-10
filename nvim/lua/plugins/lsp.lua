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
  },

  config = function()
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

      vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = {
          ".git",
          ".hg",
          "package.json",
          "vite.config.js",
          "vite.config.ts",
          "tsconfig.json",
        },
      })

      -- Lua LSP
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
            },
          },
        },
      })

      -- VTS LSP
      vim.lsp.config("vtsls", {
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
        capabilities = capabilities,
        settings = {
          vtsls = {
            enableMoveToFileCodeAction = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 256,
              },
            },
          },
          typescript = {
            tsserver = { maxTsServerMemory = 4096 },
            format = { enable = false },
            suggest = {
              diagnostics = true,
              completeFunctionCalls = true,
              includeCompletionsForModuleExports = true,
              includeCompletionsWithInsertText = true,
            },
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            preferences = {
              importModuleSpecifier = "relative",
              includePackageJsonAutoImports = "on",
              quotePreference = "auto",
            },
          },
          javascript = {
            format = { enable = false },
            suggest = {
              diagnostics = true,
              completeFunctionCalls = true,
              includeCompletionsForModuleExports = true,
              includeCompletionsWithInsertText = true,
            },
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            preferences = {
              importModuleSpecifier = "relative",
              includePackageJsonAutoImports = "on",
              quotePreference = "auto",
            },
          },
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })

      -- CSS Modules
      vim.lsp.config("cssmodules_ls", {
        capabilities = capabilities,
        filetypes = { "typescriptreact", "javascriptreact", "tsx", "jsx" },
      })

      -- CSS LSP
      vim.lsp.config("cssls", {
        capabilities = capabilities,
        settings = {
          css = { validate = true, lint = { unknownAtRules = "ignore" } },
          scss = { validate = true, lint = { unknownAtRules = "ignore" } },
          less = { validate = true, lint = { unknownAtRules = "ignore" } },
        },
      })

      vim.lsp.config("tailwindcss", {
        capabilities = capabilities,
        root_dir = require("lspconfig.util").root_pattern(
          "tailwind.config.js",
          "tailwind.config.ts",
          "postcss.config.js",
          "package.json",
          ".git"
        ),
      })

      -- Emmet
      vim.lsp.config("emmet_ls", {
        capabilities = capabilities,
        filetypes = {
          "html",
          "javascriptreact",
          "typescriptreact",
          "css",
          "scss",
        },
      })

      -- ESLint
      vim.lsp.config("eslint", {
        capabilities = capabilities,
        settings = {
          experimental = {
            useFlatConfig = true,
          },
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

      -- Enable all listed servers
      for _, s in ipairs(servers) do
        vim.lsp.enable(s)
      end
    end

    -- Run setup
    vim.schedule(setup)
  end,
}
