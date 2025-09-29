return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  cmd = "Telescope",

  opts = function()
    local conf = require "nvchad.configs.telescope"

    conf.defaults = vim.tbl_deep_extend("force", conf.defaults or {}, {
      file_ignore_patterns = {
        "node_modules",
        ".git/",
        "%.jpg",
        "%.jpeg",
        "%.png",
        "%.webp",
        "%.otf",
        "%.ttf",
        "%.lock",
        "%.zip",
        "%.tar.gz",
        "__pycache__",
        "venv",
        "%.pyc",
      },
    })

    -- ui-select dropdown theme
    conf.extensions = vim.tbl_deep_extend("force", conf.extensions or {}, {
      ["ui-select"] = require("telescope.themes").get_dropdown {},
    })

    return conf
  end,

  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension "ui-select"
  end,

  keys = {
    -- Telescope core
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Page" },
    { "<leader>fm", "<cmd>Telescope marks<CR>", desc = "Find Marks" },
    { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Find Oldfiles" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Command Palette" },
    { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix List" },
    { "<leader>fl", "<cmd>Telescope loclist<CR>", desc = "Location List" },
    {
      "<leader>fa",
      "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      desc = "Find All Files",
    },
    { "<leader>fgc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Grep Current Buffer" },
    { "<leader>fgl", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
  },
}
