return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      dependencies = "rafamadriz/friendly-snippets",

      opts = {
        history = true,
        updateevents = "TextChanged,TextChangedI",
      },

      config = function(_, opts)
        local ls = require("luasnip")
        ls.config.set_config(opts)

        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_snipmate").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load()
      end,
    },

    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",

      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },

      config = function(_, opts)
        local npairs = require("nvim-autopairs")
        npairs.setup(opts)

        local cmp_ok, cmp = pcall(require, "cmp")
        if cmp_ok then
          local cmp_ap = require("nvim-autopairs.completion.cmp")
          cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
        end
      end,
    },

    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    { "hrsh7th/cmp-nvim-lua", ft = "lua" },
    { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
    { "hrsh7th/cmp-buffer", event = "InsertEnter" },
    { "https://codeberg.org/FelipeLema/cmp-async-path.git", event = "InsertEnter" },
  },

  -- I basically copy nvchad code :p
  opts = function()
    local cmp = require("cmp")
    local cmp_ui = require("nvconfig").ui.cmp
    local cmp_style = cmp_ui.style
    local format_color = require("nvchad.cmp.format")

    local atom_styled = cmp_style == "atom" or cmp_style == "atom_colored"
    local fields = (atom_styled or cmp_ui.icons_left) and { "kind", "abbr", "menu" } or { "abbr", "kind", "menu" }

    local disabled_ft = {
      ["TelescopePrompt"] = true,
      ["snacks_picker_input"] = true,
      ["copilot-chat"] = true,
      ["markdown"] = true,
    }

    local options = {
      formatting = {
        format = function(entry, item)
          local icons = require("nvchad.icons.lspkind")
          local icon = icons[item.kind] or ""
          local kind = item.kind or ""

          if atom_styled then
            item.menu = kind
            item.menu_hl_group = "LineNr"
            item.kind = " " .. icon .. " "
          elseif cmp_ui.icons_left then
            item.menu = kind
            item.menu_hl_group = "CmpItemKind" .. kind
            item.kind = icon
          else
            item.kind = " " .. icon .. " " .. kind
            item.menu_hl_group = "comment"
          end

          if kind == "Color" and cmp_ui.format_colors.lsp then
            format_color.lsp(entry, item, (not (atom_styled or cmp_ui.icons_left) and kind) or "")
          end

          local abbr_maxwidth = 30
          if #item.abbr > abbr_maxwidth then
            item.abbr = string.sub(item.abbr, 1, abbr_maxwidth) .. "…"
          end

          return item
        end,

        fields = fields,
      },

      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },

      window = {
        completion = {
          scrollbar = false,
          side_padding = atom_styled and 0 or 1,
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
          border = atom_styled and "none" or "single",
        },

        documentation = {
          border = "single",
          winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
          max_width = 80,
          max_height = 20,
        },
      },

      completion = { completeopt = "menu,menuone,noselect" },

      enabled = function()
        return not disabled_ft[vim.bo.filetype]
      end,

      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      performance = {
        debounce = 100,
        throttle = 50,
      },

      mapping = {
        ["<C-Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

        -- ["<C-Up>"] = cmp.mapping.select_prev_item(),
        -- ["<C-Down>"] = cmp.mapping.select_next_item(),
        ["<S-Up>"] = cmp.mapping.scroll_docs(-4),
        ["<S-Down>"] = cmp.mapping.scroll_docs(4),
        ["<C-S-Down>"] = cmp.mapping.complete(),
        ["<C-c>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = false,
        }),

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

      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 10, max_item_count = 20 },
        { name = "luasnip", priority = 9, max_item_count = 10 },
        { name = "buffer", keyword_length = 3, max_item_count = 5 },
        { name = "nvim_lua", priority = 7 },
        { name = "async_path", priority = 6 },
      }),

      experimental = {
        ghost_text = false,
      },
    }

    cmp.setup(options)
  end,
}
