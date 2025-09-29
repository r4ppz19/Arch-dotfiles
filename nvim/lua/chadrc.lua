-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  theme_toggle = { "gruvbox", "gruvchad" },
  transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    FloatBorder = { fg = "grey_fg" },
  },
}

M.ui = {
  tabufline = {
    lazyload = false,
  },
  statusline = {
    separator_style = "block",
  },
}

M.term = {
  float = {
    relative = "editor",
    row = 0.13,
    col = 0.15,
    width = 0.7,
    height = 0.6,
    border = "single",
  },
}

return M
