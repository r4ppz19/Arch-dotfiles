return {

  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  cmd = "Spectre",
  keys = {
    {
      "<leader>S",
      function()
        require("spectre").toggle()
      end,
      desc = "Toggle Spectre",
    },
    {
      "<leader>Sw",
      function()
        require("spectre").open_visual({ select_word = true })
      end,
      desc = "Search current word",
    },
    {
      "<leader>Sw",
      function()
        require("spectre").open_visual()
      end,
      mode = "v",
      desc = "Search current word",
    },
    {
      "<leader>Sp",
      function()
        require("spectre").open_file_search({ select_word = true })
      end,
      desc = "Search on current file",
    },
  },
}
