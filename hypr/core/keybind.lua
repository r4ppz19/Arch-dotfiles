local var = require("util.variable")
local zen = require("util.zen")

-- Application launching
hl.bind(var.mainMod .. " + RETURN", hl.dsp.exec_cmd(var.terminal))
hl.bind(var.mainMod .. " + E", hl.dsp.exec_cmd(var.filemanager))
hl.bind(var.mainMod .. " + D", hl.dsp.exec_cmd(var.launcher))
hl.bind(var.mainMod .. " + T", hl.dsp.exec_cmd(var.terminal))
hl.bind(var.mainMod .. " + L", hl.dsp.exec_cmd(var.lockscreen))
hl.bind(var.mainMod .. " + N", hl.dsp.exec_cmd(var.notifpanel))
hl.bind(var.mainMod .. " + slash", hl.dsp.exec_cmd(var.websearch))

-- Window management
hl.bind(var.mainMod .. " + SHIFT + K", hl.dsp.window.kill())
hl.bind(var.mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(var.mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(var.mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(var.mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))

-- Toggle zen mode
hl.bind(var.mainMod .. "+ SHIFT + Z", function()
  zen.toggle()
end)

-- Power menu
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(var.powermenu))

-- Focus management
hl.bind("ALT + TAB", hl.dsp.layout("rollnext"))
hl.bind("ALT + SHIFT + TAB ", hl.dsp.layout("rollprev"))

hl.bind("CTRL + ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("CTRL + ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ previous = true }))

-- Go to previous workspace
hl.bind(var.mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Move focus with arrow keys
hl.bind(var.mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(var.mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(var.mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(var.mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Move windows with arrow keys
hl.bind(var.mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(var.mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(var.mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(var.mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Move floating windows
hl.bind(var.mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(var.mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(var.mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(var.mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- Mouse
hl.config({
  binds = {
    drag_threshold = 5,
  },
})

-- Mouse window movement and resizing
hl.bind(var.mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(var.mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Scroll through workspaces with mouse wheel
hl.bind(var.mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(var.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- Page up/down for workspace navigation
hl.bind("Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("Page_Down", hl.dsp.focus({ workspace = "e+1" }))

-- Switch workspaces with vars.mainMod + [0-9]
for i = 1, 10 do
  local key = i % 10
  hl.bind(var.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(var.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
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

hl.bind(var.mainMod .. " + W", hl.dsp.workspace.toggle_special("window1"))
hl.bind(var.mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:window1" }))

-- Second special workspace (scratchpad)
hl.workspace_rule({
  workspace = "special:window2",
  gaps_in = 3,
  gaps_out = { top = 120, right = 240, bottom = 120, left = 240 },
})

hl.bind(var.mainMod .. " + backslash", hl.dsp.workspace.toggle_special("window2"))
hl.bind(var.mainMod .. " + SHIFT + backslash", hl.dsp.window.move({ workspace = "special:window2" }))

-- Minimize workspace
hl.workspace_rule({
  workspace = "special:minimize",
  gaps_in = 2,
  gaps_out = { top = 5, right = 5, bottom = 5, left = 5 },
  border_size = 0,
})

hl.bind(var.mainMod .. " + grave", hl.dsp.workspace.toggle_special("minimize"))
hl.bind(var.mainMod .. " + X", hl.dsp.window.move({ workspace = "special:minimize" }))
