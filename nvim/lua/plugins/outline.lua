return {
  "hedyhli/outline.nvim",
  event = "LspAttach",
  config = function()
    local map = require("utils.map")
    map("n", "<leader>ls", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
    require("outline").setup({
      outline_window = {
        -- Percentage or integer of columns
        width = 30,

        -- Auto close the outline window if goto_location is triggered and not for
        -- peek_location
        auto_close = false,

        -- Automatically scroll to the location in code when navigating outline window.
        auto_jump = true,
        -- boolean or integer for milliseconds duration to apply a temporary highlight
        -- when jumping. false to disable.
        jump_highlight_duration = 500,
      },
    })
  end,
}
