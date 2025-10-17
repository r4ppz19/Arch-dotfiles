local M = {}

function M.setup(capabilities)
  -- Lua LSP
  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
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

  -- Java LSP
  local jdtls_capabilities = vim.deepcopy(capabilities)
  jdtls_capabilities.textDocument.semanticTokens = vim.NIL

  vim.lsp.config("jdtls", {
    capabilities = jdtls_capabilities,
    root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "gradlew", "mvnw", ".git" },
    on_attach = function(client)
      -- Forcefully disable semantic tokens if server ignores capability
      client.server_capabilities.semanticTokensProvider = nil
    end,
    settings = {
      java = {
        home = "/usr/lib/jvm/java-21-openjdk/",
        completion = {
          importOrder = { "java", "javax", "com", "org" },
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
          },
          filteredTypes = {
            "com.sun.*",
            "java.awt.*",
            "jdk.*",
            "sun.*",
          },
        },
        project = {
          referencedLibraries = {
            "lib/**/*.jar",
          },
        },
        maven = {
          downloadSources = true,
        },
        gradle = {
          wrapper = {
            enabled = true,
          },
        },
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/java-21-openjdk/",
          },
        },
      },
    },
  })

  -- CSS Modules
  vim.lsp.config("cssmodules_ls", {
    capabilities = capabilities,
    filetypes = { "typescriptreact", "javascriptreact", "tsx", "jsx" },
  })

  -- CSS LSP
  vim.lsp.config("cssls", {
    capabilities = capabilities,
    root_markers = { "package.json", ".git" },
    settings = {
      css = { validate = true, lint = { unknownAtRules = "ignore" } },
      scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      less = { validate = true, lint = { unknownAtRules = "ignore" } },
    },
  })

  -- Tailwind CSS
  vim.lsp.config("tailwindcss", {
    capabilities = capabilities,
    root_markers = {
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "postcss.config.ts",
      "package.json",
      ".git",
    },
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
    root_markers = {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc.json",
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "package.json",
      ".git",
    },
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

  -- Python LSP
  vim.lsp.config("pyright", {
    capabilities = capabilities,
    root_markers = {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "pyrightconfig.json",
      ".git",
    },
  })

  -- Rust LSP
  vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  })

  -- Bash LSP
  vim.lsp.config("bashls", {
    capabilities = capabilities,
    root_markers = { ".git" },
  })

  -- C/C++ LSP
  vim.lsp.config("clangd", {
    capabilities = capabilities,
    root_markers = {
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      ".git",
    },
  })

  -- HTML LSP
  vim.lsp.config("html", {
    capabilities = capabilities,
    root_markers = { "package.json", ".git" },
  })

  -- JSON LSP
  vim.lsp.config("jsonls", {
    capabilities = capabilities,
    root_markers = { "package.json", ".git" },
  })

  -- Markdown LSP
  vim.lsp.config("marksman", {
    capabilities = capabilities,
    root_markers = { ".marksman.toml", ".git" },
  })

  -- XML LSP
  vim.lsp.config("lemminx", {
    capabilities = capabilities,
    root_markers = { "pom.xml", ".git" },
  })

  -- Hyprland LSP
  vim.lsp.config("hyprls", {
    capabilities = capabilities,
    root_markers = { "hyprland.conf", ".git" },
  })
end

return M
