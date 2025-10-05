return {
  "hrsh7th/nvim-cmp",
  opts = function()
    local opts = require "nvchad.configs.cmp"
    local cmp = require "cmp"

    opts.mapping = vim.tbl_extend(
      "force",
      opts.mapping,
      cmp.mapping.preset.insert {
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = false },
      }
    )

    opts.mapping["<Tab>"] = cmp.config.disable
    opts.mapping["<S-Tab>"] = cmp.config.disable

    return opts
  end,
}
