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
		-- FloatBorder = { fg = "blue" }
	},
}

-- M.nvdash = { load_on_startup = true }
M.ui = {
	tabufline = {
		lazyload = false,
	},
	statusline = {
		separator_style = "block",
	},
}

return M
