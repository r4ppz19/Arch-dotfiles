local var = require("util.variable")
local mouse = require("util.mouse")
local eyetemp = require("util.eyetemp")
local layout = require("appearance.layout")

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
hl.bind(var.mod .. " + A", hl.dsp.submap("AI Slop"))

hl.define_submap("AI Slop", "reset", function()
  hl.bind(var.mod .. " + V", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.microsoft_copilot))
  hl.bind(var.mod .. " + K", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.kimi))
  hl.bind(var.mod .. " + X", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.github_copilot))
  hl.bind(var.mod .. " + C", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.chatgpt))
  hl.bind(var.mod .. " + P", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.perplexity))
  hl.bind(var.mod .. " + G", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.gemini))
  hl.bind(var.mod .. " + D", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.deepseek))
  hl.bind(var.mod .. " + N", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.notebooklm))
  hl.bind(var.mod .. " + Q", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.qwen))
  hl.bind(var.mod .. " + H", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.huggingface))

  hl.bind("V", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.microsoft_copilot))
  hl.bind("K", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.kimi))
  hl.bind("X", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.github_copilot))
  hl.bind("C", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.chatgpt))
  hl.bind("P", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.perplexity))
  hl.bind("G", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.gemini))
  hl.bind("D", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.deepseek))
  hl.bind("N", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.notebooklm))
  hl.bind("Q", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.qwen))
  hl.bind("H", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.huggingface))
  hl.bind("A", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.claude))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + SPACE", hl.dsp.submap("Applications"))

hl.define_submap("Applications", "reset", function()
  -- Website shortcuts
  hl.bind("A", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.annas_archive))
  hl.bind("W", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.w3schools))
  hl.bind("Y", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.youtube))
  hl.bind("F", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.facebook))
  hl.bind("G", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.github))
  hl.bind("D", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.drive))
  hl.bind("M", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.mail))
  hl.bind("E", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.getemoji))
  hl.bind("N", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.news))
  hl.bind("T", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.monkeytype))
  hl.bind("C", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.cloudflare))

  -- Applications
  hl.bind("V", hl.dsp.exec_cmd(var.ide))
  hl.bind("P", hl.dsp.exec_cmd(var.passmanager))

  -- App mode shortcuts
  hl.bind(var.mod .. " + S", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.spotify))
  hl.bind(var.mod .. " + N", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.news))
  hl.bind(var.mod .. " + D", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.devdocs))
  hl.bind(var.mod .. " + G", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.github))
  hl.bind(var.mod .. " + F", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.facebook))
  hl.bind(var.mod .. " + Y", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.youtube))
  hl.bind(var.mod .. " + T", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.monkeytype))
  hl.bind(var.mod .. " + M", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.ytmusic))
  hl.bind(var.mod .. " + SHIFT + M", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.mappltv))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- SCHOOL WORKS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + S", hl.dsp.submap("School"))

hl.define_submap("School", "reset", function()
  hl.bind(var.mod .. " + C", hl.dsp.exec_cmd(var.school_browser .. " --app=" .. websites.classroom))
  hl.bind(var.mod .. " + M", hl.dsp.exec_cmd(var.school_browser .. " --app=" .. websites.mail))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- UTILITIES SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + U", hl.dsp.submap("util"))

-- Helper func run cmd + submap reset
local function cmd_with_reset(command)
  return function()
    hl.dispatch(hl.dsp.exec_cmd(command))
    hl.dispatch(hl.dsp.submap("reset"))
  end
end

hl.define_submap("util", function()
  hl.bind("SHIFT + S", cmd_with_reset(var.screenshotfull))
  hl.bind("S", cmd_with_reset(var.screenshot))
  hl.bind("R", cmd_with_reset(var.record))
  hl.bind("O", cmd_with_reset(var.ocr))
  hl.bind("C", cmd_with_reset(var.colorpicker))
  hl.bind("E", function()
    eyetemp.toggle()
  end)

  hl.bind("1", hl.dsp.exec_cmd(var.mediactl .. " mute"))
  hl.bind("2", hl.dsp.exec_cmd(var.mediactl .. " mic-mute"))
  hl.bind("3", hl.dsp.exec_cmd(var.mediactl .. " volume-down"), { repeating = true })
  hl.bind("4", hl.dsp.exec_cmd(var.mediactl .. " volume-up"), { repeating = true })
  hl.bind("5", hl.dsp.exec_cmd(var.mediactl .. " brightness-down"), { repeating = true })
  hl.bind("6", hl.dsp.exec_cmd(var.mediactl .. " brightness-up"), { repeating = true })
  hl.bind("7", hl.dsp.exec_cmd("playerctl previous"))
  hl.bind("8", hl.dsp.exec_cmd("playerctl next"))
  hl.bind("9", hl.dsp.exec_cmd("playerctl play-pause"))

  -- Layout cycling
  hl.bind("l", function()
    layout.cycle_next()
  end)
  hl.bind("SHIFT + L", function()
    layout.cycle_back()
  end)

  hl.bind("Shift_L", hl.dsp.exec_cmd("true"))
  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- RESIZE WINDOWS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + R", hl.dsp.submap("resize"))

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
hl.bind(var.mod .. " + Q", hl.dsp.submap("mouse-mode"))

hl.define_submap("mouse-mode", function()
  -- Normal speed
  hl.bind("left", function()
    mouse.move("left")
  end, { repeating = true })
  hl.bind("down", function()
    mouse.move("down")
  end, { repeating = true })
  hl.bind("right", function()
    mouse.move("right")
  end, { repeating = true })
  hl.bind("up", function()
    mouse.move("up")
  end, { repeating = true })

  -- Slow speen
  hl.bind("SHIFT + left", function()
    mouse.move("left", "slow")
  end, { repeating = true })
  hl.bind("SHIFT + down", function()
    mouse.move("down", "slow")
  end, { repeating = true })
  hl.bind("SHIFT + right", function()
    mouse.move("right", "slow")
  end, { repeating = true })
  hl.bind("SHIFT + up", function()
    mouse.move("up", "slow")
  end, { repeating = true })

  hl.bind("KP_Insert", function()
    mouse.click("left")
  end)
  hl.bind("KP_Enter", function()
    mouse.click("right")
  end)
  hl.bind("KP_Delete", function()
    mouse.click("middle")
  end)
  hl.bind("KP_End", function()
    mouse.toggle()
  end)

  hl.bind("Q", function()
    mouse.click("left")
  end)
  hl.bind("W", function()
    mouse.click("right")
  end)
  hl.bind("E", function()
    mouse.click("middle")
  end)
  hl.bind("R", function()
    mouse.toggle()
  end)

  hl.bind("escape", function()
    mouse.reset()
  end)
end)
