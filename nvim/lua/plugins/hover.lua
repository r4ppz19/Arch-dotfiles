return {
  "lewis6991/hover.nvim",
  event = "LspAttach",
  config = function()
    require("hover").setup({
      providers = { "configs.hover_provider" },
      title = false,
      preview_opts = {
        border = "single",
        wrap = true,
        max_width = 85,
        max_height = 15,
      },
    })

    vim.api.nvim_set_hl(0, "HoverWindow", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "HoverBorder", { fg = "#82A497" })

    local hover = require("hover")

    -- double-tap detection
    local last = 0
    vim.keymap.set("n", "<S-C-Up>", function()
      local now = vim.loop.now()
      if now - last < 300 then
        hover.enter()
      else
        hover.open()
      end
      last = now
    end, { desc = "Hover (double tap enters docs)" })
  end,
}
