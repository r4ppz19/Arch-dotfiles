return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  opts = function()
    dofile(vim.g.base46_cache .. "telescope")

    return {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        initial_mode = "insert",
        path_display = { "truncate" },
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          n = { ["q"] = require("telescope.actions").close },
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ["<S-Down>"] = require("telescope.actions").preview_scrolling_down,
            ["<S-Up>"] = require("telescope.actions").preview_scrolling_up,
          },
        },
      },

      extensions_list = { "themes", "terms", "ui-select" },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
      },
    }
  end,

  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)

    for _, ext in ipairs(opts.extensions_list or {}) do
      telescope.load_extension(ext)
    end
  end,

  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Page" },
    { "<leader>fm", "<cmd>Telescope marks<CR>", desc = "Find Marks" },
    { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Command Palette" },
    { "<leader>fH", "<cmd>Telescope command_history<CR>", desc = "Command History" },
    { "<leader>fs", "<cmd>Telescope spell_suggest<CR>", desc = "Command Palette" },

    { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix List" },
    { "<leader>fl", "<cmd>Telescope loclist<CR>", desc = "Location List" },

    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },

    { "<leader>FF", "<cmd>Telescope live_grep<CR>", desc = "Live Grep Project" },
    { "<leader>Ff", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Grep Current Buffer" },
  },
}
