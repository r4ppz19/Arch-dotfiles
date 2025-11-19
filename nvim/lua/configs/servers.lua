local M = {}

local function make_lua_library()
  local lib = {}
  lib[vim.fn.expand("$VIMRUNTIME/lua")] = true
  lib[vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true
  lib[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true
  lib["${3rd}/luv/library"] = true
  return lib
end

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
          library = make_lua_library(),
          maxPreload = 1000,
          preloadFileSize = 1000,
        },
        telemetry = { enable = false },
      },
    },
  })

  -- Java LSP
  local java_home = os.getenv("JAVA_HOME")
  vim.lsp.config("jdtls", {
    capabilities = capabilities,
    root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "gradlew", "mvnw" },
    settings = {
      java = {
        autobuild = {
          enabled = true,
        },
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
          },
          filteredTypes = { "com.sun.*", "java.awt.*", "jdk.*", "sun.*" },
          importOrder = { "java", "javax", "com", "org", "lombok" },
        },
        home = java_home,
        configuration = {
          runtimes = {
            {
              name = "JavaSE-21",
              path = java_home,
            },
          },
        },
        contentProvider = {
          preferred = "fernflower",
        },
        format = {
          enabled = true,
        },
        gradle = {
          offline = true,
          version = "8.5",
          wrapper = {
            enabled = true,
          },
        },
        import = {
          externalAnnotation = {
            enabled = true,
          },
          gradle = {
            enabled = true,
          },
          maven = {
            enabled = true,
          },
        },
        maven = {
          downloadSources = true,
          updateSnapshots = true,
        },
        project = {
          importPrompt = {
            enabled = true,
          },
          referencedLibraries = { "lib/**/*.jar", "./out/**/*.jar" },
        },
        saveActions = {
          organizeImports = true,
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
      },
    },
    on_attach = function(client)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  })

  -- CSS Modules
  vim.lsp.config("cssmodules_ls", {
    capabilities = capabilities,
    filetypes = { "typescriptreact", "javascriptreact" },
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
    filetypes = { "css", "scss", "sass", "less", "typescriptreact", "javascriptreact" },
  })

  -- Emmet
  vim.lsp.config("emmet_ls", {
    capabilities = capabilities,
    filetypes = {
      "html",
      "javascriptreact",
      "typescriptreact",
      "css",
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
