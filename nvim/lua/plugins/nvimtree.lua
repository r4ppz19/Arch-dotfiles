return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  opts = function()
    return {
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = {},
      },
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 30,
      },

      actions = {
        open_file = {
          quit_on_open = true,
        },
      },

      git = {
        enable = true,
      },

      renderer = {
        root_folder_label = false,
        highlight_git = "icon",
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            default = "󰈚",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
            },
          },
        },
      },
    }
  end,

  keys = {
    { "<M-e>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree " },
    { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus Nvimtree" },
  },
}
