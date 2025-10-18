return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      -- snippet plugin
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        require("luasnip").config.set_config(opts)

        -- vscode format
        require("luasnip.loaders.from_vscode").lazy_load {
          exclude = vim.g.vscode_snippets_exclude or {},
        }
        if vim.g.vscode_snippets_path and vim.g.vscode_snippets_path ~= "" then
          require("luasnip.loaders.from_vscode").lazy_load {
            paths = vim.g.vscode_snippets_path,
          }
        end

        -- snipmate format
        require("luasnip.loaders.from_snipmate").lazy_load()

        -- lua format
        require("luasnip.loaders.from_lua").lazy_load()
      end,
    },

    -- autopairing of (){}[] etc
    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)

        -- setup cmp for autopairs
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },

    {
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua" },
      config = function()
        require("copilot_cmp").setup()
      end,
    },

    -- cmp sources plugins
    {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "https://codeberg.org/FelipeLema/cmp-async-path.git",
      "ray-x/cmp-treesitter",
    },
  },
  opts = function()
    dofile(vim.g.base46_cache .. "cmp")

    local cmp = require "cmp"

    local options = {
      completion = { completeopt = "menu,menuone,noselect" },

      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      mapping = {
        ["<C-Up>"] = cmp.mapping.select_prev_item(),
        ["<C-Down>"] = cmp.mapping.select_next_item(),
        ["<S-Up>"] = cmp.mapping.scroll_docs(-4),
        ["<S-Down>"] = cmp.mapping.scroll_docs(4),
        ["<C-S-Down>"] = cmp.mapping.complete(),
        ["<Esc>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = false,
        },

        -- NOTE: might need later? idk
        -- ["<fuckingannoyingpieceofshit>"] = cmp.mapping(function(fallback)
        --   if require("luasnip").expand_or_jumpable() then
        --     require("luasnip").expand_or_jump()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      },

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "async_path" },
        { name = "treesitter" },
        { name = "copilot" },
      },
    }

    options = vim.tbl_deep_extend("force", options, require "nvchad.cmp")
    cmp.setup(options)
  end,
}
