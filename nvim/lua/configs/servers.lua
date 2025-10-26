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
          maxPreload = 1000,
          preloadFileSize = 1000,
        },
        telemetry = { enable = false },
      },
    },
  })

  -- VTS LSP
  vim.lsp.config("vtsls", {
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
    capabilities = capabilities,
    settings = {
      vtsls = {
        enableMoveToFileCodeAction = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
            entriesLimit = 128,
          },
        },
      },
      typescript = {
        tsserver = {
          maxTsServerMemory = 2048,
        },
        format = { enable = false },
        suggest = {
          completions = {
            completeFunctionCalls = true,
          },
        },
        inlayHints = {
          includeInlayParameterNameHints = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
        },
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsWithInsertText = true,
          importModuleSpecifier = "relative",
          includePackageJsonAutoImports = "auto",
          quotePreference = "auto",
        },
      },
      javascript = {
        format = { enable = false },
        suggest = {
          completions = {
            completeFunctionCalls = true,
          },
        },
        inlayHints = {
          includeInlayParameterNameHints = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
        },
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsWithInsertText = true,
          importModuleSpecifier = "relative",
          includePackageJsonAutoImports = "auto",
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
    root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "gradlew", "mvnw" },
    on_attach = function(client)
      -- Forcefully disable semantic tokens if server ignores capability
      client.server_capabilities.semanticTokensProvider = nil
    end,
    settings = {
      java = {
        home = "/usr/lib/jvm/java-21-openjdk/",
        configuration = {
          runtimes = {
            {
              name = "JavaSE-21",
              path = "/usr/lib/jvm/java-21-openjdk/",
            },
          },
        },
        completion = {
          importOrder = { "java", "javax", "com", "org", "lombok" },
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
            "./out/**/*.jar",
          },
          importPrompt = {
            enabled = true,
          },
        },
        maven = {
          downloadSources = true,
          updateSnapshots = true,
        },
        gradle = {
          version = "8.5",
          wrapper = {
            enabled = true,
          },
          offline = true,
        },
        autobuild = {
          enabled = true,
        },
        import = {
          maven = {
            enabled = true,
          },
          gradle = {
            enabled = true,
          },
          externalAnnotation = {
            enabled = true,
          },
        },
        saveActions = {
          organizeImports = true,
        },
        format = {
          enabled = true,
          settings = {
            url = vim.fn.stdpath "config" .. "/java-formatter.xml",
            profile = "GoogleStyle",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 999,
            staticStarThreshold = 999,
          },
        },
        typeHierarchy = {
          multipleInheritance = true,
        },
        contentProvider = {
          preferred = "fernflower",
        },
      },
    },
  })

  -- CSS Modules
  vim.lsp.config("cssmodules_ls", {
    capabilities = capabilities,
    filetypes = { "typescriptreact", "javascriptreact", "tsx", "jsx" },
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      less = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  })

  -- CSS LSP
  vim.lsp.config("cssls", {
    capabilities = capabilities,
    root_markers = { "package.json" },
    settings = {
      css = { validate = true, lint = { unknownAtRules = "ignore" } },
      scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      less = { validate = true, lint = { unknownAtRules = "ignore" } },
    },
  })

  -- CSS Variables
  vim.lsp.config("css_variables", {
    capabilities = capabilities,
    filetypes = { "css", "scss", "sass", "less", "pcss", "typescriptreact", "javascriptreact" },
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
      "vue",
      "svelte",
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
    on_attach = function(client, _)
      -- Reduce diagnostics frequency for better performance
      client.server_capabilities.documentFormattingProvider = false
    end,
  })

  -- Python LSP - optimized
  vim.lsp.config("pyright", {
    capabilities = capabilities,
    root_markers = {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "pyrightconfig.json",
    },
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "basic",
        },
      },
    },
  })

  -- Rust LSP
  vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    root_markers = { "Cargo.toml", "rust-project.json" },
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        procMacro = {
          enable = true,
          attributes = {
            enable = true,
          },
        },
        -- Limit memory usage
        checkOnSave = {
          command = "check",
        },
      },
    },
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
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--folding-ranges",
    },
  })

  -- HTML LSP
  vim.lsp.config("html", {
    capabilities = capabilities,
    root_markers = { "package.json" },
    settings = {
      html = {
        format = { enable = false },
        suggest = {
          element = {
            wrap = {
              snippets = {},
            },
          },
        },
      },
    },
  })

  -- JSON LSP
  vim.lsp.config("jsonls", {
    capabilities = capabilities,
    root_markers = { "package.json" },
    settings = {
      json = {
        format = { enable = false },
        schemas = {},
        validate = { enable = true },
      },
    },
  })

  -- Markdown LSP
  vim.lsp.config("marksman", {
    capabilities = capabilities,
    root_markers = { ".marksman.toml" },
  })

  -- XML LSP
  vim.lsp.config("lemminx", {
    capabilities = capabilities,
    root_markers = { "pom.xml" },
  })

  -- Hyprland LSP
  vim.lsp.config("hyprls", {
    capabilities = capabilities,
    root_markers = { "hyprland.conf" },
  })
end

return M
