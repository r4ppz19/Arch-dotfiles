return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  opts = function()
    return {
      pickers = {
        spell_suggest = {
          layout_strategy = "vertical",
          layout_config = {
            prompt_position = "top",
            width = 0.5,
            height = 0.6,
          },
        },
        command_history = {
          layout_strategy = "vertical",
          layout_config = {
            prompt_position = "top",
            width = 0.5,
            height = 0.6,
          },
        },
        commands = {
          layout_strategy = "vertical",
          layout_config = {
            prompt_position = "top",
            width = 0.5,
            height = 0.6,
          },
        },
        find_files = {
          hidden = true,
          follow_symlinks = false,
        },
        live_grep = {
          additional_args = function()
            return {
              "--smart-case",
              "--hidden",
              "--glob=!**/.git/*",
              "--glob=!**/node_modules/*",
              "--glob=!**/.cache/*",
            }
          end,
        },
        grep_string = {
          additional_args = function()
            return {
              "--smart-case",
              "--hidden",
              "--glob=!**/.git/*",
              "--glob=!**/node_modules/*",
              "--glob=!**/.cache/*",
            }
          end,
        },
      },

      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        initial_mode = "insert",
        path_display = { "truncate" },

        file_ignore_patterns = {
          "vendor/.*",
          "%.git/.*",
          "node_modules/.*",
          "%.cache/.*",
          "%.npm/.*",
          "__pycache__/.*",
          "%.pytest_cache/.*",
          "%.tox/.*",
          "%.coverage.*",
          "coverage/.*",
          "dist/.*",
          "build/.*",
          "target/.*",
          "%.stack-work/.*",
          "%.hg/.*",
          "%.svn/.*",
          "%.DS_Store",
          "Thumbs%.db",
          "tags",
        },

        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            width = 0.87,
            height = 0.80,
          },
          vertical = {
            mirror = false,
            width = 0.95,
            height = 0.95,
          },
          center = {
            width = 0.4,
            height = 0.4,
          },
        },

        -- Performance related settings
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!**/.git/*",
        },

        preview = {
          timeout = 100,
          delay = 0,
          check_mime_type = true,
        },

        git = {
          max_count = 10000,
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
    { "<M-f>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find Buffers" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },

    { "<leader>FF", "<cmd>Telescope live_grep<CR>", desc = "Live Grep Project" },
    { "<leader>Ff", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Grep Current Buffer" },

    { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
    { "<leader>fm", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
    { "<leader>fH", "<cmd>Telescope command_history<CR>", desc = "Command History" },

    { "<leader>fM", "<cmd>Telescope marks<CR>", desc = "Marks" },
    { "<leader>fs", "<cmd>Telescope spell_suggest<CR>", desc = "Spell Suggest" },
    { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix List" },
    { "<leader>fl", "<cmd>Telescope loclist<CR>", desc = "Location List" },
    { "<leader>fB", "<cmd>Telescope file_browser<CR>", desc = "File Browser" },
  },
}
