return {
  git = {
    enable = false,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
  renderer = {
    highlight_git = false,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },
    },
  },
  view = {
    width = 25,
    side = "left",
  },
}