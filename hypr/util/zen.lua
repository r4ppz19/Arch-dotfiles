local notify = require("util.notify")

local M = {}

local zen = false

local config = {
  normal = {
    general = { gaps_in = 10, gaps_out = 20 },
    decoration = { rounding = 1, rounding_power = 5 },
    wallpaper = os.getenv("DOTFILES") .. "/wallpaper/wallpaper2.png",
    waybar = "start",
  },
  zen = {
    general = { gaps_out = 0, gaps_in = 1, border_size = 0 },
    decoration = { rounding = 0, rounding_power = 0 },
    wallpaper = os.getenv("DOTFILES") .. "/wallpaper/plain-wallpaper.png",
    waybar = "stop",
  },
}

local function apply_config(mode)
  local conf = config[mode]
  hl.config({
    general = conf.general,
    decoration = conf.decoration,
  })
  hl.dispatch(hl.dsp.exec_cmd("hyprctl hyprpaper wallpaper  HDMI-A-1," .. conf.wallpaper .. ",cover"))
  hl.dispatch(hl.dsp.exec_cmd("systemctl --user " .. conf.waybar .. " waybar.service"))
end

function M.is_zen()
  return zen
end

function M.toggle()
  if zen then
    apply_config("normal")
    zen = false
    notify.send("Normal Mode", nil, {
      timeout = 1000,
      app_name = "Zen Mode",
      icon = "dialog-information",
      transient = true,
    })
  else
    apply_config("zen")
    zen = true
    notify.send("Zen Mode", nil, {
      timeout = 1000,
      app_name = "Zen Mode",
      icon = "dialog-information",
      transient = true,
    })
  end
end

return M
