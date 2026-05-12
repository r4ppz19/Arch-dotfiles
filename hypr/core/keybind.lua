local vars = require("core.variable")

-- Application launching
hl.bind(vars.mainMod .. " + RETURN", hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.mainMod .. " + E", hl.dsp.exec_cmd(vars.filemanager))
hl.bind(vars.mainMod .. " + D", hl.dsp.exec_cmd(vars.launcher))
hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.mainMod .. " + L", hl.dsp.exec_cmd(vars.lockscreen))
hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd(vars.notifpanel))
hl.bind(vars.mainMod .. " + slash", hl.dsp.exec_cmd(vars.websearch))

-- WINDOW MANAGEMENT
hl.bind(vars.mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(vars.mainMod .. " + SHIFT + K", hl.dsp.window.kill())
hl.bind(vars.mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(vars.mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreenstate 0 2"))
hl.bind(vars.mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(vars.mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd(vars.zen))

-- Power menu
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(vars.powermenu))

-- Focus management
hl.bind("ALT + TAB", hl.dsp.layout("rollnext"))
hl.bind("ALT + SHIFT + TAB ", hl.dsp.layout("rollprev"))

hl.bind("CTRL + ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("CTRL + ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ previous = true }))

-- Go to previous workspace
hl.bind(vars.mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Move focus with arrow keys
hl.bind(vars.mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(vars.mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(vars.mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(vars.mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Move windows with arrow keys
hl.bind(vars.mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(vars.mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(vars.mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(vars.mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Move floating windows
hl.bind(vars.mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(vars.mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(vars.mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(vars.mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- Mouse
hl.config({
  binds = {
    drag_threshold = 5,
  },
})

-- Mouse window movement and resizing
hl.bind(vars.mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(vars.mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Zoom with mouse wheel + shift
hl.bind(vars.mainMod .. " + SHIFT + mouse_up", hl.dsp.exec_cmd(vars.zoom .. " out"))
hl.bind(vars.mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd(vars.zoom .. " in"))

-- Special workspace (scratchpad)
hl.workspace_rule({
  workspace = "special:window1",
  gaps_in = 3,
  gaps_out = {
    top = 120,
    right = 240,
    bottom = 120,
    left = 240,
  },
})

hl.bind(vars.mainMod .. " + W", hl.dsp.workspace.toggle_special({ workspace = "special:window1" }))
hl.bind(vars.mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:window1" }))

-- SecondSpecial workspace (scratchpad)
hl.workspace_rule({
  workspace = "special:window2",
  gaps_in = 3,
  gaps_out = {
    top = 120,
    right = 240,
    bottom = 120,
    left = 240,
  },
})

hl.bind(vars.mainMod .. " + backslash", hl.dsp.workspace.toggle_special({ workspace = "special:windows2" }))
hl.bind(vars.mainMod .. " + SHIFT + backslash", hl.dsp.window.move({ workspace = "special:windows2" }))

-- Minimize workspace
hl.workspace_rule({
  workspace = "special:minimize",
  gaps_in = 2,
  gaps_out = {
    top = 5,
    right = 5,
    bottom = 5,
    left = 5,
  },
  border_size = 0,
})

hl.bind(vars.mainMod .. " + grave", hl.dsp.workspace.toggle_special("special:minimize"))
hl.bind(vars.mainMod .. " + X", hl.dsp.window.move({ workspace = "special:minimize" }))

-- Scroll through workspaces with mouse wheel
hl.bind(vars.mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(vars.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- Page up/down for workspace navigation
hl.bind("Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("Page_Down", hl.dsp.focus({ workspace = "e+1" }))

-- Switch workspaces with vars.mainMod + [0-9]
for i = 1, 10 do
  local key = i % 10
  hl.bind(vars.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(vars.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(vars.mediactl .. " volume-up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(vars.mediactl .. " volume-down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(vars.mediactl .. " mute"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(vars.mediactl .. " mic-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(vars.mediactl .. " brightness-up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(vars.mediactl .. " brightness-down"), { repeating = true })
