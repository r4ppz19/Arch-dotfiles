local M = {}

local function make_lua_library()
  local lib = {}
  lib[vim.fn.expand("$VIMRUNTIME/lua")] = true
  lib[vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true
  lib[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true
  lib["${3rd}/luv/library"] = true
  lib["~/Arch-dotfiles/nvim"] = true
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

  -- Java
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.expand("~/.local/share/jdtls-workspace/" .. project_name)

  local java_home = os.getenv("JAVA_HOME")
  local mason = vim.fn.stdpath("data") .. "/mason"
  local lombok_jar = vim.fn.expand(mason .. "/share/jdtls/lombok.jar")

  -- Find the Equinox launcher once; abort early if not found
  local launcher = vim.fn.glob(mason .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher == "" then
    vim.notify("JDT LS launcher not found under Mason. Is jdtls installed?", vim.log.levels.ERROR)
  end

  vim.lsp.config("jdtls", {
    capabilities = capabilities,
    root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "gradlew", "mvnw", ".git" },

    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=false",
      "-Dlog.level=INFO",
      "-Xmx2G",
      -- The following opens were historically needed for JDK 9; not required for 21. Keep only if you actually need them.
      -- "--add-modules=ALL-SYSTEM",
      -- "--add-opens", "java.base/java.util=ALL-UNNAMED",
      -- "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-javaagent:" .. lombok_jar,
      "-jar",
      launcher,
      "-configuration",
      mason .. "/packages/jdtls/config_linux",
      "-data",
      workspace_dir,
    },

    settings = {
      java = {
        home = java_home,
        autobuild = { enabled = true },
        contentProvider = { preferred = { "fernflower" } },
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.springframework.boot.SpringApplication.*",
            "org.springframework.boot.autoconfigure.SpringBootApplication.*",
            "org.springframework.web.bind.annotation.*",
            "org.springframework.http.ResponseEntity.*",
          },
          filteredTypes = {
            "com.sun.*",
            "java.awt.*",
            "jdk.*",
            "sun.*",
            "org.springframework.cglib.*",
            "org.springframework.boot.loader.*",
          },
          importOrder = { "java", "javax", "com", "org", "lombok" },
        },
        referencesCodeLens = { enabled = true },
        configuration = {
          updateBuildConfiguration = "automatic",
          maven = {
            userSettings = vim.fn.expand("~/.m2/settings.xml"),
            globalSettings = "/etc/maven/settings.xml",
          },
          runtimes = {
            { name = "JavaSE-21", path = java_home, default = true },
            -- more
            -- { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
            -- { name = "JavaSE-11", path = "/usr/lib/jvm/java-11-openjdk" },
          },
        },

        format = { enabled = true },
        import = {
          gradle = {
            enabled = true,
            offline = { enabled = true },
            version = "8.5",
            wrapper = { enabled = true },
          },
          maven = { enabled = true },
          -- Optionally add exclusions to avoid importing huge dirs
          -- exclusions = { "**/node_modules/**", "**/.metadata/**", "**/archetype-resources/**", "**/META-INF/maven/**" },
        },

        maven = {
          downloadSources = true,
          updateSnapshots = true,
        },

        project = {
          referencedLibraries = { "lib/**/*.jar", "./out/**/*.jar" },
        },

        saveActions = { organizeImports = true },

        sources = {
          organizeImports = {
            starThreshold = 999,
            staticStarThreshold = 999,
          },
        },
      },
    },
    on_attach = function(client)
      -- highlighting sucks
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

  vim.lsp.config("yamlls", {
    capabilities = capabilities,
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      yaml = {
        format = {
          enable = false,
        },
      },
    },
  })

  vim.lsp.config("docker_compose_language_service", {
    capabilities = capabilities,
    root_markers = {
      "docker-compose.yaml",
      "docker-compose.yml",
      "compose.yaml",
      "compose.yml",
    },
    filetypes = { "yml" },
  })

  vim.lsp.config("docker_language_server", {
    capabilities = capabilities,
    root_markers = {
      "docker-compose.yaml",
      "docker-compose.yml",
      "compose.yaml",
      "compose.yml",
      "Dockerfile",
    },
    filetypes = { "dockerfile" },
  })

  vim.lsp.config("postgres_lsp", {
    capabilities = capabilities,
    filetypes = { "sql" },
  })
end

return M
