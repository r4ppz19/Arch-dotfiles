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
      typescript = {
        tsserver = {
          maxTsServerMemory = 2048,
        },
        format = { enable = false },
      },
      javascript = {
        format = { enable = false },
      },
    },
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
  })

  -- Hyprland LSP
  vim.lsp.config("hyprls", {
    capabilities = capabilities,
    root_markers = { "hyprland.conf" },
    filetypes = { "hyprlang" },
  })

  vim.lsp.config("bashls", {
    capabilities = capabilities,
    filetypes = { "bash", "zsh", "sh" },
  })
end

return M
