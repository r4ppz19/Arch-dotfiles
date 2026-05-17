local M = {}

local state = "released"

local function run(cmd)
  hl.dispatch(hl.dsp.exec_cmd(cmd))
end

--- Mouse click
function M.click(button)
  if button == "left" then
    run("ydotool click 0x40 0x80")
    hl.dispatch(hl.dsp.submap("reset"))
  elseif button == "right" then
    run("ydotool click 0x41 0x81")
  elseif button == "middle" then
    run("ydotool click 0x42 0x82")
  end
end

-- Toggle press/release + copy
function M.toggle()
  if state == "released" then
    state = "pressed"
    run("ydotool click 0x40")
  else
    state = "released"
    run("ydotool click 0x80")

    hl.timer(function()
      run("ydotool key 29:1 46:1 46:0 29:0") -- Ctrl+C
      run("ydotool click 0x40 0x80") -- clear selection
      run([[notify-send -h boolean:transient:true "Copied." -i dialog-information -t 1400]])
      hl.dispatch(hl.dsp.submap("reset"))
    end, { timeout = 100, type = "oneshot" })
  end
end

function M.reset()
  state = "released"
  run("ydotool click 0x80")
  hl.dispatch(hl.dsp.submap("reset"))
end

--- Moves the mouse cursor
function M.move(direction, speed)
  local step = (speed == "slow") and 10 or 30
  if direction == "left" then
    run(string.format("ydotool mousemove -- %d %d", -step, 0))
  elseif direction == "right" then
    run(string.format("ydotool mousemove -- %d %d", step, 0))
  elseif direction == "up" then
    run(string.format("ydotool mousemove -- %d %d", 0, -step))
  elseif direction == "down" then
    run(string.format("ydotool mousemove -- %d %d", 0, step))
  end
end

return M
