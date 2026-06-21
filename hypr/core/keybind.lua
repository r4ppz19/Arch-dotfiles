local var = require("util.variable")
local zen = require("util.zen")
local zoom = require("util.zoom")

-- Application launching
hl.bind(var.mod .. " + RETURN", hl.dsp.exec_cmd(var.terminal))
hl.bind(var.mod .. " + T", hl.dsp.exec_cmd(var.terminal))
hl.bind(var.mod .. " + L", hl.dsp.exec_cmd(var.lockscreen))
hl.bind(var.mod .. " + N", hl.dsp.exec_cmd(var.notifpanel))
hl.bind(var.mod .. " + slash", hl.dsp.exec_cmd(var.websearch))
hl.bind(var.mod .. " + V", hl.dsp.exec_cmd(var.gui_ide))
hl.bind(var.mod .. " + E", hl.dsp.exec_cmd(var.gui_filemanager))
hl.bind(var.mod .. " + P", hl.dsp.exec_cmd(var.passmanager))

-- TUIs
hl.bind(var.mod .. " + SHIFT + E", hl.dsp.exec_cmd(var.terminal .. " -e " .. var.tui_filemanager))
hl.bind(var.mod .. " + SHIFT + T", hl.dsp.exec_cmd(var.terminal .. " -e " .. var.taskmanager))
hl.bind(var.mod .. " + SHIFT + N", hl.dsp.exec_cmd(var.terminal .. " -e " .. var.tui_ide))

local toggle_waybar = [[
    if systemctl --user is-active --quiet waybar.service; then
        systemctl --user disable --now waybar.service
    else
        systemctl --user enable --now waybar.service
    fi
]]
hl.bind(var.mod .. " + B", hl.dsp.exec_cmd(toggle_waybar))

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

-- Zoom in and out
hl.bind("SUPER + ALT + mouse_down", function()
  zoom.zoom_in()
end)
hl.bind("SUPER + ALT + mouse_up", function()
  zoom.zoom_out()
end)
hl.bind("SUPER + ALT + mouse:272", function()
  zoom.zoom_reset()
end)

-- Power menu
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(var.powermenu))

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
    scroll_event_delay = 0, -- snappy zooming
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
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(var.mediactl .. " brightness-up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(var.mediactl .. " brightness-down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(var.mediactl .. " mute"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(var.mediactl .. " mic-mute"))

hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- Special workspace (scratchpad)
hl.workspace_rule({
  workspace = "special:window1",
  gaps_in = 3,
  gaps_out = { top = 180, right = 350, bottom = 180, left = 350 },
})

hl.bind(var.mod .. " + W", hl.dsp.workspace.toggle_special("window1"))
hl.bind(var.mod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:window1" }))

-- Minimize workspace
hl.workspace_rule({
  workspace = "special:minimize",
  gaps_in = 2,
  gaps_out = { top = 5, right = 5, bottom = 5, left = 5 },
  border_size = 0,
})

hl.bind(var.mod .. " + grave", hl.dsp.workspace.toggle_special("minimize"))
hl.bind(var.mod .. " + X", hl.dsp.window.move({ workspace = "special:minimize" }))
