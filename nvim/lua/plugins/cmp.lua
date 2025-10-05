return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        require("luasnip").config.set_config(opts)
        require "nvchad.configs.luasnip"
      end,
    },
    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
    {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "https://codeberg.org/FelipeLema/cmp-async-path.git",
      "zbirenbaum/copilot-cmp",
      "hrsh7th/nvim-cmp",
    },
  },

  opts = function()
    local cmp = require "cmp"
    local default_opts = require "nvchad.configs.cmp"

    -- Arrow navigation for completion
    default_opts.mapping["<C-Up>"] = cmp.mapping.select_prev_item()
    default_opts.mapping["<C-Down>"] = cmp.mapping.select_next_item()

    default_opts.mapping["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
    }

    default_opts.completion.completeopt = "menu,menuone,noselect"

    table.insert(default_opts.sources, 1, { name = "copilot" })

    return default_opts
  end,
}
