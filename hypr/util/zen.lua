local M = {}

local zen = false

local function set_normal()
  hl.config({
    general = { gaps_out = 15, gaps_in = 8, border_size = 2 },
    decoration = { rounding = 1, rounding_power = 5 },
  })
  hl.dispatch(
    hl.dsp.exec_cmd("hyprctl hyprpaper wallpaper eDP-1," .. os.getenv("DOTFILES") .. "/wallpaper/wallpaper2.png,cover")
  )
  hl.dispatch(hl.dsp.exec_cmd("systemctl --user start waybar.service"))
end

local function set_zen()
  hl.config({
    general = { gaps_out = 0, gaps_in = 1, border_size = 0 },
    decoration = { rounding = 0, rounding_power = 0 },
  })
  hl.dispatch(
    hl.dsp.exec_cmd(
      "hyprctl hyprpaper wallpaper eDP-1," .. os.getenv("DOTFILES") .. "/wallpaper/plain-wallpaper.png,cover"
    )
  )
  hl.dispatch(hl.dsp.exec_cmd("systemctl --user stop waybar.service"))
end

function M.toggle()
  if zen then
    set_normal()
    zen = false
  else
    set_zen()
    zen = true
  end
end

return M
