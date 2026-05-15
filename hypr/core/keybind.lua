local var = require("util.variable")
local zen = require("util.zen")

-- Application launching
hl.bind(var.mod .. " + RETURN", hl.dsp.exec_cmd(var.terminal))
hl.bind(var.mod .. " + E", hl.dsp.exec_cmd(var.filemanager))
hl.bind(var.mod .. " + D", hl.dsp.exec_cmd(var.launcher))
hl.bind(var.mod .. " + T", hl.dsp.exec_cmd(var.terminal))
hl.bind(var.mod .. " + L", hl.dsp.exec_cmd(var.lockscreen))
hl.bind(var.mod .. " + N", hl.dsp.exec_cmd(var.notifpanel))
hl.bind(var.mod .. " + slash", hl.dsp.exec_cmd(var.websearch))

-- Window management
hl.bind(var.mod .. " + SHIFT + K", hl.dsp.window.kill())
hl.bind(var.mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(var.mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Fullscreen
hl.bind(var.mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(
  var.mod .. " + SHIFT + F",
  hl.dsp.window.fullscreen_state({
    internal = 0,
    client = 2,
    action = "toggle",
  })
)

-- Toggle zen mode
hl.bind(var.mod .. "+ SHIFT + Z", function()
  zen.toggle()
end)

-- Power menu
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(var.powermenu))

-- Layout: master
hl.bind("ALT + TAB", hl.dsp.layout("rollnext"))
hl.bind("ALT + SHIFT + TAB ", hl.dsp.layout("rollprev"))

-- Go to previous workspace
hl.bind(var.mod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Move focus with arrow keys
hl.bind(var.mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(var.mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(var.mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(var.mod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Move windows with arrow keys
hl.bind(var.mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(var.mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(var.mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(var.mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Move floating windows
hl.bind(var.mod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(var.mod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(var.mod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(var.mod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- Mouse
hl.config({
  binds = {
    drag_threshold = 5,
  },
})

-- Mouse window movement and resizing
hl.bind(var.mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(var.mod .. " + mouse:273", hl.dsp.window.resize())

-- Scroll through workspaces with mouse wheel
hl.bind(var.mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(var.mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- Page up/down for workspace navigation
hl.bind("Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("Page_Down", hl.dsp.focus({ workspace = "e+1" }))

-- Switch workspaces with vars.mainMod + [0-9]
for i = 1, 10 do
  local key = i % 10
  hl.bind(var.mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(var.mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(var.mediactl .. " volume-up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(var.mediactl .. " volume-down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(var.mediactl .. " mute"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(var.mediactl .. " mic-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(var.mediactl .. " brightness-up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(var.mediactl .. " brightness-down"), { repeating = true })

-- Special workspace (scratchpad)
hl.workspace_rule({
  workspace = "special:window1",
  gaps_in = 3,
  gaps_out = { top = 120, right = 240, bottom = 120, left = 240 },
})

hl.bind(var.mod .. " + W", hl.dsp.workspace.toggle_special("window1"))
hl.bind(var.mod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:window1" }))

-- Second special workspace (scratchpad)
hl.workspace_rule({
  workspace = "special:window2",
  gaps_in = 3,
  gaps_out = { top = 120, right = 240, bottom = 120, left = 240 },
})

hl.bind(var.mod .. " + backslash", hl.dsp.workspace.toggle_special("window2"))
hl.bind(var.mod .. " + SHIFT + backslash", hl.dsp.window.move({ workspace = "special:window2" }))

-- Minimize workspace
hl.workspace_rule({
  workspace = "special:minimize",
  gaps_in = 2,
  gaps_out = { top = 5, right = 5, bottom = 5, left = 5 },
  border_size = 0,
})

hl.bind(var.mod .. " + grave", hl.dsp.workspace.toggle_special("minimize"))
hl.bind(var.mod .. " + X", hl.dsp.window.move({ workspace = "special:minimize" }))
