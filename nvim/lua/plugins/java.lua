return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap", -- for debugging UI
      "rcarriga/nvim-dap-ui",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- Initialize nvim-java (MUST be before lspconfig.jdtls.setup)
      require("java").setup {
        jdk = {
          auto_install = false,
        },
        -- notifications = { dap = true },
      }

      -- Configure jdtls via lspconfig with your Java 21 path
      local lspconfig = require "lspconfig"

      -- Build capabilities (ok if cmp isn't present)
      local capabilities
      pcall(function()
        capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.completion.completionItem =
          vim.tbl_deep_extend("force", capabilities.textDocument.completion.completionItem or {}, {
            documentationFormat = { "markdown", "plaintext" },
            snippetSupport = true,
            preselectSupport = true,
            insertReplaceSupport = true,
            labelDetailsSupport = true,
            deprecatedSupport = true,
            commitCharactersSupport = true,
            tagSupport = { valueSet = { 1 } },
            resolveSupport = {
              properties = { "documentation", "detail", "additionalTextEdits" },
            },
          })
        -- Hard-disable semantic tokens at the capability layer (belt)
        if capabilities.textDocument then
          capabilities.textDocument.semanticTokens = nil
        end
      end)

      -- Per-client kill switch for semantic tokens (suspenders)
      local function on_attach(client, bufnr)
        if client.server_capabilities and client.server_capabilities.semanticTokensProvider then
          client.server_capabilities.semanticTokensProvider = nil
          pcall(function()
            -- Neovim 0.10 API; safe to pcall
            if vim.lsp.semantic_tokens then
              vim.lsp.semantic_tokens.stop(bufnr, client.id)
              vim.lsp.semantic_tokens.refresh(bufnr, client.id)
            end
          end)
        end
      end

      lspconfig.jdtls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk",
                  default = true,
                },
              },
            },
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            references = { includeDecompiledSources = true },
            signatureHelp = { enabled = true },
            format = { enabled = true },
          },
        },
      }

      -- Treesitter Java parser (syntax highlighting is NOT LSP)
      pcall(function()
        require("nvim-treesitter.configs").setup {
          ensure_installed = { "java" },
          highlight = { enable = true },
        }
      end)
    end,
  },
}
