local R = {
  "██████╗ ",
  "██╔══██╗",
  "██████╔╝",
  "██╔══██╗",
  "██║  ██║",
  "╚═╝  ╚═╝",
}

local F4 = {
  "██╗  ██╗",
  "██║  ██║",
  "███████║",
  "╚════██║",
  "     ██║",
  "     ╚═╝",
}

local P = {
  "██████╗ ",
  "██╔══██╗",
  "██████╔╝",
  "██╔═══╝ ",
  "██║     ",
  "╚═╝     ",
}

local Z = {
  "███████╗",
  "╚══███╔╝",
  "  ███╔╝ ",
  " ███╔╝  ",
  "███████╗",
  "╚══════╝",
}

local spacer = "  "
local logo_lines = {}
for i = 1, 6 do
  logo_lines[i] = R[i] .. spacer .. F4[i] .. spacer .. P[i] .. spacer .. P[i] .. spacer .. Z[i]
end

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("dashboard").setup {
      theme = "hyper",
      hide = {
        tabline = true,
        statusline = true,
        winbar = true,
      },
      config = {
        header = logo_lines,
        week_header = { enable = false },
        packages = { enable = true },
        project = { enable = false },
        mru = { enable = false },
        shortcut = {},
        footer = {},
      },
    }
  end,
}
