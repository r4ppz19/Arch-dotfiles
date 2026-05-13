local vars = require("core.variable")

local websites = {
  microsoft_copilot = "https://copilot.microsoft.com/chats/temporary",
  github_copilot = "https://github.com/copilot",
  kimi = "https://www.kimi.com",
  chatgpt = "https://chatgpt.com/?temporary-chat=true",
  perplexity = "https://www.perplexity.ai",
  gemini = "https://gemini.google.com/app",
  deepseek = "https://chat.deepseek.com",
  notebooklm = "https://notebooklm.google.com",
  qwen = "https://chat.qwen.ai/?temporary-chat=true",
  claude = "https://claude.ai",
  huggingface = "https://huggingface.co/chat",

  annas_archive = "https://annas-archive.li",
  w3schools = "https://www.w3schools.com",
  youtube = "https://www.youtube.com",
  facebook = "https://www.facebook.com/messages",
  github = "https://github.com/r4ppz",
  drive = "https://drive.google.com/drive/my-drive",
  mail = "https://mail.google.com",
  getemoji = "https://getemoji.com",
  news = "https://news.ycombinator.com",
  monkeytype = "https://monkeytype.com",
  cloudflare = "https://dash.cloudflare.com",
  spotify = "https://open.spotify.com",
  devdocs = "https://devdocs.io",
  ytmusic = "https://music.youtube.com",
  mappltv = "https://mappl.tv",
  classroom = "https://classroom.google.com",
}

-- ============================================================================
-- AI APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + A", hl.dsp.submap("AI Slop"))

hl.define_submap("AI Slop", "reset", function()
  hl.bind(vars.mainMod .. " + V", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.microsoft_copilot))
  hl.bind(vars.mainMod .. " + K", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.kimi))
  hl.bind(vars.mainMod .. " + X", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.github_copilot))
  hl.bind(vars.mainMod .. " + C", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.chatgpt))
  hl.bind(vars.mainMod .. " + P", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.perplexity))
  hl.bind(vars.mainMod .. " + G", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.gemini))
  hl.bind(vars.mainMod .. " + D", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.deepseek))
  hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.notebooklm))
  hl.bind(vars.mainMod .. " + Q", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.qwen))
  hl.bind(vars.mainMod .. " + H", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.huggingface))

  hl.bind("V", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.microsoft_copilot))
  hl.bind("K", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.kimi))
  hl.bind("X", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.github_copilot))
  hl.bind("C", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.chatgpt))
  hl.bind("P", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.perplexity))
  hl.bind("G", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.gemini))
  hl.bind("D", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.deepseek))
  hl.bind("N", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.notebooklm))
  hl.bind("Q", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.qwen))
  hl.bind("H", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.huggingface))
  hl.bind("A", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.claude))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + SPACE", hl.dsp.submap("Applications"))

hl.define_submap("Applications", "reset", function()
  -- Website shortcuts
  hl.bind("A", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.annas_archive))
  hl.bind("W", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.w3schools))
  hl.bind("Y", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.youtube))
  hl.bind("F", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.facebook))
  hl.bind("G", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.github))
  hl.bind("D", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.drive))
  hl.bind("M", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.mail))
  hl.bind("E", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.getemoji))
  hl.bind("N", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.news))
  hl.bind("T", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.monkeytype))
  hl.bind("C", hl.dsp.exec_cmd(vars.browser .. " --new-tab " .. websites.cloudflare))

  -- Applications
  hl.bind("V", hl.dsp.exec_cmd(vars.ide))
  hl.bind("P", hl.dsp.exec_cmd(vars.passmanager))

  -- App mode shortcuts
  hl.bind(vars.mainMod .. " + S", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.spotify))
  hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.news))
  hl.bind(vars.mainMod .. " + D", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.devdocs))
  hl.bind(vars.mainMod .. " + G", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.github))
  hl.bind(vars.mainMod .. " + F", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.facebook))
  hl.bind(vars.mainMod .. " + Y", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.youtube))
  hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.monkeytype))
  hl.bind(vars.mainMod .. " + M", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.ytmusic))
  hl.bind(vars.mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(vars.browser .. " --app=" .. websites.mappltv))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- SCHOOL WORKS SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + S", hl.dsp.submap("School"))

hl.define_submap("School", "reset", function()
  hl.bind(vars.mainMod .. " + C", hl.dsp.exec_cmd(vars.browserForSchool .. " --app=" .. websites.classroom))
  hl.bind(vars.mainMod .. " + M", hl.dsp.exec_cmd(vars.browserForSchool .. " --app=" .. websites.mail))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- UTILITIES SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + U", hl.dsp.submap("util"))

hl.define_submap("util", function()
  hl.bind("SHIFT + S", hl.dsp.exec_cmd(vars.screenshotfull))
  hl.bind("S", hl.dsp.exec_cmd(vars.screenshot))
  hl.bind("R", hl.dsp.exec_cmd(vars.record))
  hl.bind("O", hl.dsp.exec_cmd(vars.ocr))
  hl.bind("C", hl.dsp.exec_cmd(vars.colorpicker))
  hl.bind("E", hl.dsp.exec_cmd(vars.eyetemp))

  hl.bind("1", hl.dsp.exec_cmd(vars.mediactl .. " mute"))
  hl.bind("2", hl.dsp.exec_cmd(vars.mediactl .. " mic-mute"))
  hl.bind("3", hl.dsp.exec_cmd(vars.mediactl .. " volume-down"))
  hl.bind("4", hl.dsp.exec_cmd(vars.mediactl .. " volume-up"))
  hl.bind("5", hl.dsp.exec_cmd(vars.mediactl .. " brightness-down"))
  hl.bind("6", hl.dsp.exec_cmd(vars.mediactl .. " brightness-up"))
  hl.bind("7", hl.dsp.exec_cmd("playerctl previous"))
  hl.bind("8", hl.dsp.exec_cmd("playerctl next"))
  hl.bind("9", hl.dsp.exec_cmd("playerctl play-pause"))

  hl.bind("Shift_L", hl.dsp.exec_cmd("true"))
  hl.bind("catchall", hl.dsp.submap("reset"))
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

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- MOUSE MODE SUBMAP
-- ============================================================================
hl.bind(vars.mainMod .. " + Q", hl.dsp.submap("mouse-mode"))

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
  hl.bind("KP_Insert", hl.dsp.exec_cmd(vars.mouseclick .. " left"))
  hl.bind("KP_Enter", hl.dsp.exec_cmd(vars.mouseclick .. " right"))
  hl.bind("KP_Delete", hl.dsp.exec_cmd(vars.mouseclick .. " middle"))
  hl.bind("KP_End", hl.dsp.exec_cmd(vars.mouseclick .. " toggle"))

  hl.bind("Q", hl.dsp.exec_cmd(vars.mouseclick .. " left"))
  hl.bind("W", hl.dsp.exec_cmd(vars.mouseclick .. " right"))
  hl.bind("E", hl.dsp.exec_cmd(vars.mouseclick .. " middle"))
  hl.bind("R", hl.dsp.exec_cmd(vars.mouseclick .. " toggle"))

  hl.bind("escape", hl.dsp.exec_cmd(vars.mouseclick .. " reset"))
end)
