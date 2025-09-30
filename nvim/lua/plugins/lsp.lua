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
    "nvim-java/nvim-java",
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
  },

  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
      root_markers = { ".git", ".hg", "package.json", "vite.config.js", "vite.config.ts", "tsconfig.json" },
    })

    vim.lsp.config("java", {
      capabilities = capabilities,
      install = { maven = true, gradle = true },
      spring = { enable = true },
      dap = { enable = true, hotcodereplace = "auto" },
      test = { enable = true },
      root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
      settings = {
        java = {
          eclipse = { downloadSources = true },
          maven = { downloadSources = true, updateSnapshots = true },
          implementationsCodeLens = { enabled = true },
          referencesCodeLens = { enabled = true },
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.assertj.core.api.Assertions.*",
              "org.junit.Assert.*",
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
              "org.mockito.ArgumentMatchers.*",
            },
            filteredTypes = {
              "com.sun.*",
              "sun.*",
              "jdk.*",
              "java.awt.*",
            },
          },
          sources = { organizeImports = { starThreshold = 99, staticStarThreshold = 99 } },
          codeGeneration = {
            useBlocks = true,
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = { useJava7Objects = true },
          },
        },
      },
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

    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
  end,
}
