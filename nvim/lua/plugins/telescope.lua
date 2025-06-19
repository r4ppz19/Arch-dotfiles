return {
  "nvim-telescope/telescope.nvim", tag = "0.1.8",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    "sharkdp/fd",
    "BurntSushi/ripgrep",
    "nvim-telescope/telescope-fzf-native.nvim"
  },

  config = function()

    -- Keybindings
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

    -- Configuration
    require('telescope').setup({
      defaults = {
        -- Default configuration options for all pickers
        
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
        horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
        },
        path_display = { "smart" },
        mappings = {
          n = {
            ["<esc>"] = require("telescope.actions").close,
          },
        },
      },
    })
  end,
}
