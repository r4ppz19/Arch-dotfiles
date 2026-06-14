local var = require("util.variable")
local mouse = require("util.mouse")
local eyetemp = require("util.eyetemp")
local notify = require("util.notify")
local zen = require("util.zen")

local submap_timer = nil
local function start_submap_timer()
  if submap_timer then
    submap_timer:set_enabled(false)
  end
  submap_timer = hl.timer(function()
    hl.dispatch(hl.dsp.submap("reset"))
  end, { timeout = 2000, type = "oneshot" })
end

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
  duckduckgo = "https://duck.ai/chat",
  mistral = "https://chat.mistral.ai/incognito",

  annas_archive = "https://annas-archive.is",
  reddit = "https://www.reddit.com",
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
  archwiki = "https://wiki.archlinux.org",
  twitter = "https://x.com/",
  render = "https://dashboard.render.com",
  figma = "https://www.figma.com",
}

-- ============================================================================
-- AI APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + A", function()
  hl.dispatch(hl.dsp.submap("AI Slop"))
  start_submap_timer()

  if zen.is_zen() then
    notify.send("Submap", "AI Slop", {
      timeout = 1000,
      app_name = "Submap",
      icon = "dialog-information",
      transient = true,
    })
  end
end)

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
  hl.bind(var.mod .. " + O", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.duckduckgo))
  hl.bind(var.mod .. " + M", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.mistral))

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
  hl.bind("O", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.duckduckgo))
  hl.bind("M", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.mistral))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + SPACE", function()
  hl.dispatch(hl.dsp.submap("Applications"))
  start_submap_timer()

  if zen.is_zen() then
    notify.send("Submap", "Applications", {
      timeout = 1000,
      app_name = "Submap",
      icon = "dialog-information",
      transient = true,
    })
  end
end)

hl.define_submap("Applications", "reset", function()
  -- New Tap shortcuts
  hl.bind("G", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.github))
  hl.bind("D", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.drive))
  hl.bind("M", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.mail))
  hl.bind("E", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.getemoji))
  hl.bind("T", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.monkeytype))
  hl.bind("C", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.cloudflare))
  hl.bind("R", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.render))
  hl.bind("F", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.figma))

  -- App mode shortcuts
  hl.bind(var.mod .. " + G", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.github))
  hl.bind(var.mod .. " + D", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.drive))
  hl.bind(var.mod .. " + M", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.mail))
  hl.bind(var.mod .. " + E", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.getemoji))
  hl.bind(var.mod .. " + T", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.monkeytype))
  hl.bind(var.mod .. " + C", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.cloudflare))
  hl.bind(var.mod .. " + R", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.render))
  hl.bind(var.mod .. " + F", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.figma))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- MEDIA
-- ============================================================================

local submap_entry_timer = nil
hl.bind(var.mod .. " + M", function()
  -- Cancel any pending entry
  if submap_entry_timer then
    submap_entry_timer:set_enabled(false)
  end

  -- Enter submap after a small delay so this event doesn't also hit the submap bind
  submap_entry_timer = hl.timer(function()
    start_submap_timer()
    hl.dispatch(hl.dsp.submap("Media"))
  end, { timeout = 50, type = "oneshot" })
end)

hl.define_submap("Media", "reset", function()
  -- Website shortcuts
  hl.bind("A", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.annas_archive))
  hl.bind("Y", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.youtube))
  hl.bind("R", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.reddit))
  hl.bind("F", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.facebook))
  hl.bind("N", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.news))
  hl.bind("S", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.spotify))
  hl.bind("M", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.ytmusic))
  hl.bind("W", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.archwiki))
  hl.bind("X", hl.dsp.exec_cmd(var.browser .. " --new-tab " .. websites.twitter))

  -- App mode shortcuts
  hl.bind(var.mod .. " + A", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.annas_archive))
  hl.bind(var.mod .. " + Y", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.youtube))
  hl.bind(var.mod .. " + R", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.reddit))
  hl.bind(var.mod .. " + F", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.facebook))
  hl.bind(var.mod .. " + N", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.news))
  hl.bind(var.mod .. " + S", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.spotify))
  hl.bind(var.mod .. " + M", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.ytmusic))
  hl.bind(var.mod .. " + W", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.archwiki))
  hl.bind(var.mod .. " + X", hl.dsp.exec_cmd(var.browser .. " --app=" .. websites.twitter))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- SCHOOL WORKS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + S", function()
  hl.dispatch(hl.dsp.submap("School"))
  start_submap_timer()

  if zen.is_zen() then
    notify.send("Submap", "School", {
      timeout = 1000,
      app_name = "Submap",
      icon = "dialog-information",
      transient = true,
    })
  end
end)

hl.define_submap("School", "reset", function()
  hl.bind(var.mod .. " + C", hl.dsp.exec_cmd(var.school_browser .. " --app=" .. websites.classroom))
  hl.bind(var.mod .. " + M", hl.dsp.exec_cmd(var.school_browser .. " --app=" .. websites.mail))

  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- UTILITIES SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + U", function()
  hl.dispatch(hl.dsp.submap("Util"))

  if zen.is_zen() then
    notify.send("Submap", "Util", {
      timeout = 1000,
      app_name = "Submap",
      icon = "dialog-information",
      transient = true,
    })
  end
end)

hl.define_submap("Util", "reset", function()
  hl.bind("SHIFT + S", hl.dsp.exec_cmd(var.screenshotfull))
  hl.bind("S", hl.dsp.exec_cmd(var.screenshot))
  hl.bind("R", hl.dsp.exec_cmd(var.record))
  hl.bind("O", hl.dsp.exec_cmd(var.ocr))
  hl.bind("C", hl.dsp.exec_cmd(var.colorpicker))
  hl.bind("E", function()
    eyetemp.toggle()
  end)

  hl.bind("Shift_L", hl.dsp.exec_cmd("true"))
  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- RESIZE WINDOWS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + R", function()
  hl.dispatch(hl.dsp.submap("resize"))

  if zen.is_zen() then
    notify.send("Submap", "Resize", {
      timeout = 1000,
      app_name = "Submap",
      icon = "dialog-information",
      transient = true,
    })
  end
end)

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
hl.bind(var.mod .. " + Q", function()
  hl.dispatch(hl.dsp.submap("Mouse Mode"))

  if zen.is_zen() then
    notify.send("Submap", "Mouse Mode", {
      timeout = 1000,
      app_name = "Submap",
      icon = "dialog-information",
      transient = true,
    })
  end
end)

hl.define_submap("Mouse Mode", function()
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
