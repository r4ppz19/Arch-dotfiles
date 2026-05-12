-- Submap configurations (modal keyhl.bindings)

local vars = require("core.variable")

-- ============================================================================
-- AI APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + A", hl.dsp.submap("AI Slop"))

hl.define_submap("AI Slop", function()
  hl.bind(vars.mainMod .. " + V", hl.dsp.exec_cmd(vars.browser .. " --app=https://copilot.microsoft.com"))
  hl.bind(vars.mainMod .. " + K", hl.dsp.exec_cmd(vars.browser .. " --app=https://www.kimi.com"))
  hl.bind(vars.mainMod .. " + X", hl.dsp.exec_cmd(vars.browser .. " --app=https://github.com/copilot"))
  hl.bind(vars.mainMod .. " + C", hl.dsp.exec_cmd(vars.browser .. " --app=https://chatgpt.com/?temporary-chat=true"))
  hl.bind(vars.mainMod .. " + P", hl.dsp.exec_cmd(vars.browser .. " --app=https://www.perplexity.ai"))
  hl.bind(vars.mainMod .. " + G", hl.dsp.exec_cmd(vars.browser .. " --app=https://gemini.google.com/app"))
  hl.bind(vars.mainMod .. " + D", hl.dsp.exec_cmd(vars.browser .. " --app=https://chat.deepseek.com"))
  hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd(vars.browser .. " --app=https://notebooklm.google.com"))
  hl.bind(vars.mainMod .. " + Q", hl.dsp.exec_cmd(vars.browser .. " --app=https://chat.qwen.ai/?temporary-chat=true"))
  hl.bind(vars.mainMod .. " + H", hl.dsp.exec_cmd(vars.browser .. " --app=https://huggingface.co/chat"))
  hl.bind(vars.mainMod .. " + A", hl.dsp.exec_cmd(vars.browser .. " --app=https://claude.ai"))
  hl.bind(
    vars.mainMod .. " + V",
    hl.dsp.exec_cmd(vars.browser .. " --app=https://copilot.microsoft.com/chats/temporary")
  )

  -- Reset to global keymap
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + SPACE", hl.dsp.submap("Applications"))

hl.define_submap("Applications", function()
  -- Website shortcuts
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://annas-archive.li"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://www.w3schools.com"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://www.youtube.com"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://www.facebook.com/messages"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://github.com/r4ppz"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://drive.google.com/drive/my-drive"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://mail.google.com"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://getemoji.com"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://news.ycombinator.com"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://monkeytype.com"))
  hl.bind("", hl.dsp.exec_cmd(vars.browser .. " --new-tab https://dash.cloudflare.com"))

  -- Applications
  hl.bind("", hl.dsp.exec_cmd(vars.ide))
  hl.bind("", hl.dsp.exec_cmd(vars.passmanager))

  -- App mode shortcuts
  hl.bind(vars.mainMod .. " + S", hl.dsp.exec_cmd(vars.browser .. " --app=https://open.spotify.com"))
  hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd(vars.browser .. " --app=https://news.ycombinator.com"))
  hl.bind(vars.mainMod .. " + D", hl.dsp.exec_cmd(vars.browser .. " --app=https://devdocs.io"))
  hl.bind(vars.mainMod .. " + G", hl.dsp.exec_cmd(vars.browser .. " --app=https://github.com/r4ppz"))
  hl.bind(vars.mainMod .. " + F", hl.dsp.exec_cmd(vars.browser .. " --app=https://www.facebook.com/messages"))
  hl.bind(vars.mainMod .. " + Y", hl.dsp.exec_cmd(vars.browser .. " --app=https://www.youtube.com"))
  hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd(vars.browser .. " --app=https://monkeytype.com"))
  hl.bind(vars.mainMod .. " + M", hl.dsp.exec_cmd(vars.browser .. " --app=https://music.youtube.com"))
  hl.bind(vars.mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(vars.browser .. " --app=https://mappl.tv"))

  -- Reset to global keymap
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- SCHOOL WORKS SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + S", hl.dsp.submap("School"))

hl.define_submap("School", function()
  hl.bind(vars.mainMod .. " + C", hl.dsp.exec_cmd(vars.browserForSchool .. " --app=https://classroom.google.com"))
  hl.bind(vars.mainMod .. " + M", hl.dsp.exec_cmd(vars.browserForSchool .. " --app=https://mail.google.com/"))

  -- Reset to global keymap
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- UTILITIES SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + U", hl.dsp.submap("util"))

hl.define_submap("util", function()
  hl.bind("SHIFT + S", hl.dsp.exec_cmd('bash -c "' .. vars.screenshotfull .. '; hyprctl dispatch submap reset"'))
  hl.bind("", hl.dsp.exec_cmd('bash -c "' .. vars.screenshot .. '; hyprctl dispatch submap reset"'))
  hl.bind("", hl.dsp.exec_cmd('bash -c "' .. vars.record .. '; hyprctl dispatch submap reset"'))
  hl.bind("", hl.dsp.exec_cmd('bash -c "' .. vars.ocr .. '; hyprctl dispatch submap reset"'))
  hl.bind("", hl.dsp.exec_cmd('bash -c "' .. vars.colorpicker .. '; hyprctl dispatch submap reset"'))
  hl.bind("", hl.dsp.exec_cmd('bash -c "' .. vars.eyetemp .. '; hyprctl dispatch submap reset"'))

  hl.bind("", hl.dsp.exec_cmd(vars.mediactl .. " mute"))
  hl.bind("", hl.dsp.exec_cmd(vars.mediactl .. " mic-mute"))
  hl.bind("", hl.dsp.exec_cmd(vars.mediactl .. " volume-down"))
  hl.bind("", hl.dsp.exec_cmd(vars.mediactl .. " volume-up"))
  hl.bind("", hl.dsp.exec_cmd(vars.mediactl .. " brightness-down"))
  hl.bind("", hl.dsp.exec_cmd(vars.mediactl .. " brightness-up"))
  hl.bind("", hl.dsp.exec_cmd("playerctl previous"))
  hl.bind("", hl.dsp.exec_cmd("playerctl next"))
  hl.bind("", hl.dsp.exec_cmd("playerctl play-pause"))

  hl.bind("Shift_L", hl.dsp.exec_cmd("true"))
  -- Reset to global keymap
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- RESIZE WINDOWS SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  hl.bind("right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

  -- Reset to global keymap
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- MOUSE MODE SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + Q", hl.dsp.submap("mouse-mode"))
hl.bind("delete", hl.dsp.submap("mouse-mode"))

-- Outside so it can be used without toggle
hl.bind("" .. "KP_Insert", hl.dsp.exec_cmd(vars.mouseclick .. " left"))
hl.bind("" .. "KP_Enter", hl.dsp.exec_cmd(vars.mouseclick .. " right"))
hl.bind("" .. "KP_Delete", hl.dsp.exec_cmd(vars.mouseclick .. " middle"))

hl.define_submap("mouse-mode", function()
  -- Normal speed arrow keys
  hl.bind("left", hl.dsp.exec_cmd("ydotool mousemove -- -30 0"), { repeating = true })
  hl.bind("down", hl.dsp.exec_cmd("ydotool mousemove -- 0 30"), { repeating = true })
  hl.bind("right", hl.dsp.exec_cmd("ydotool mousemove -- 30 0"), { repeating = true })
  hl.bind("up", hl.dsp.exec_cmd("ydotool mousemove -- 0 -30"), { repeating = true })

  -- Slower speed with Shift (precision)
  hl.bind("SHIFT + left", hl.dsp.exec_cmd("ydotool mousemove -- -10 0"), { repeating = true })
  hl.bind("SHIFT + down", hl.dsp.exec_cmd("ydotool mousemove -- 0 10"), { repeating = true })
  hl.bind("SHIFT + right", hl.dsp.exec_cmd("ydotool mousemove -- 10 0"), { repeating = true })
  hl.bind("SHIFT + up", hl.dsp.exec_cmd("ydotool mousemove -- 0 -10"), { repeating = true })

  -- Mouse clicks
  hl.bind(" + KP_Insert", hl.dsp.exec_cmd(vars.mouseclick .. " left"))
  hl.bind(" + KP_Enter", hl.dsp.exec_cmd(vars.mouseclick .. " right"))
  hl.bind(" + KP_Delete", hl.dsp.exec_cmd(vars.mouseclick .. " middle"))
  hl.bind(" + KP_End", hl.dsp.exec_cmd(vars.mouseclick .. " toggle"))

  hl.bind("Shift_L", hl.dsp.exec_cmd("true"))
  -- Reset to global keymap
  hl.bind("escape", hl.dsp.submap("reset"))
end)
