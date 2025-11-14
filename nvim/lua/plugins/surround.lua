return {
  "nvim-mini/mini.surround",
  event = "BufReadPost",
  version = "*",
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "<leader>sa", -- Add surrounding
        delete = "<leader>sd", -- Delete surrounding
        find = "<leader>sf", -- Find surrounding (to the right)
        find_left = "<leader>sF", -- Find surrounding (to the left)
        highlight = "<leader>sh", -- Highlight surrounding
        replace = "<leader>sr", -- Replace surrounding

        suffix_last = "l", -- Suffix for "find previous"
        suffix_next = "n", -- Suffix for "find next"
      },
    })
  end,
}
