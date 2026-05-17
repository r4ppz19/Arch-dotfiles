local notify = require("util.notify")

local M = {}

local modes = {
  { temperature = 3500, gamma = 90, label = "NIGHT MODE" },
  { temperature = 6000, gamma = 100, label = "DAY MODE" },
  { temperature = 4500, gamma = 100, label = "AFTERNOON MODE" },
  { temperature = 4500, gamma = 100, label = "READING MODE" },
}

local idx = 1

local function run(cmd)
  hl.dispatch(hl.dsp.exec_cmd(cmd))
end

local function apply(mode)
  run("hyprctl hyprsunset temperature " .. mode.temperature)
  run("hyprctl hyprsunset gamma " .. mode.gamma)
  notify.send(mode.label, nil, {
    timeout = 1000,
    app_name = "Toggle HyprSunset",
    icon = "dialog-information",
    transient = true,
  })
end

function M.toggle()
  idx = (idx % #modes) + 1
  apply(modes[idx])
end

return M
