local notify = require("util.notify")

local M = {}

hl.config({
  layout = {
    single_window_aspect_ratio = { 0, 0 },
    single_window_aspect_ratio_tolerance = 0.1,
  },

  general = {
    layout = "master",
  },

  dwindle = {
    preserve_split = true,
    force_split = 3,
    split_bias = 2,
  },

  master = {
    new_status = "slave",
    mfact = 0.60,
  },
})

local function get_current_layout()
  return hl.get_active_workspace().tiled_layout
end

hl.bind("ALT + TAB", function()
  if get_current_layout() == "master" then
    hl.dispatch(hl.dsp.layout("rollnext"))
  end
end)

hl.bind("ALT + SHIFT + TAB", function()
  if get_current_layout() == "master" then
    hl.dispatch(hl.dsp.layout("rollprev"))
  end
end)

local presets = {
  { name = "Master", layout = "master", gaps_in = 8, gaps_out = 15, border_size = 2, rounding = 1 },
  { name = "Dwindle", layout = "dwindle", gaps_in = 8, gaps_out = 15, border_size = 2, rounding = 1 },
  { name = "Scrolling", layout = "scrolling", gaps_in = 8, gaps_out = 15, border_size = 2, rounding = 1 },
  { name = "Display", layout = "master", gaps_in = 25, gaps_out = 50, border_size = 2, rounding = 1 },
  { name = "Minimal", layout = "dwindle", gaps_in = 1, gaps_out = 2, border_size = 0, rounding = 1 },
  {
    name = "Impractical",
    layout = "master",
    gaps_in = 1,
    gaps_out = { top = 145, right = 270, bottom = 145, left = 270 },
    border_size = 2,
    rounding = 1,
  },
}

local current = 1
local function apply_config(preset)
  hl.config({
    general = {
      layout = preset.layout,
      gaps_in = preset.gaps_in,
      gaps_out = preset.gaps_out,
      border_size = preset.border_size,
    },
    decoration = { rounding = preset.rounding },
  })
end

local function apply_preset(idx)
  local preset = presets[idx]

  notify.send("Layout", " " .. preset.name, {
    timeout = 1000,
    app_name = "Layout",
    icon = "dialog-information",
    transient = true,
  })

  apply_config(preset)
end

function M.cycle_next()
  current = current % #presets + 1
  apply_preset(current)
end

function M.cycle_back()
  current = current - 1
  if current < 1 then
    current = #presets
  end
  apply_preset(current)
end

return M
