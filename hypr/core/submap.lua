local var = require("util.variable")
local mouse = require("util.mouse")
local eyetemp = require("util.eyetemp")
local notify = require("util.notify")
local zen = require("util.zen")

--- Starts or restarts a 2-second inactivity timer.
local submap_timer = nil
local function start_submap_timer()
  if submap_timer then
    submap_timer:set_enabled(false)
  end
  submap_timer = hl.timer(function()
    hl.dispatch(hl.dsp.submap("reset"))
  end, { timeout = 2000, type = "oneshot" })
end

--- Enters a submap +  timer + notif
local function enter_submap(display_name, use_timer)
  hl.dispatch(hl.dsp.submap(display_name))
  if use_timer then
    start_submap_timer()
  end

  if zen.is_zen() then
    notify.send("Submap", display_name, {
      timeout = 1000,
      app_name = "Submap",
      icon = "dialog-information",
      transient = true,
    })
  end
end

--- Binds a key to open a URL in a browser
local function bind_site(browser, key, site_url)
  hl.bind(key, hl.dsp.exec_cmd(browser .. " --new-tab " .. site_url))
  hl.bind(var.mod .. " + " .. key, hl.dsp.exec_cmd(browser .. " --app=" .. site_url))
end

local function bind_exits()
  hl.bind("catchall", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end

-- ============================================================================
-- AI APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + A", function()
  enter_submap("AI Slop", true)
end)

hl.define_submap("AI Slop", "reset", function()
  bind_site(var.apps.browser, "V", var.websites.microsoft_copilot)
  bind_site(var.apps.browser, "K", var.websites.kimi)
  bind_site(var.apps.browser, "X", var.websites.github_copilot)
  bind_site(var.apps.browser, "C", var.websites.chatgpt)
  bind_site(var.apps.browser, "P", var.websites.perplexity)
  bind_site(var.apps.browser, "G", var.websites.gemini)
  bind_site(var.apps.browser, "D", var.websites.deepseek)
  bind_site(var.apps.browser, "N", var.websites.notebooklm)
  bind_site(var.apps.browser, "Q", var.websites.qwen)
  bind_site(var.apps.browser, "H", var.websites.huggingface)
  bind_site(var.apps.browser, "O", var.websites.duckduckgo)
  bind_site(var.apps.browser, "M", var.websites.mistral)
  bind_site(var.apps.browser, "A", var.websites.claude)
  bind_site(var.apps.browser, "T", var.websites.meta)
  bind_site(var.apps.browser, "S", var.websites.googleaistudio)

  bind_exits()
end)

-- ============================================================================
-- APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + SPACE", function()
  enter_submap("Applications", true)
end)

hl.define_submap("Applications", "reset", function()
  bind_site(var.apps.browser, "D", var.websites.drive)
  bind_site(var.apps.browser, "M", var.websites.mail)
  bind_site(var.apps.browser, "E", var.websites.getemoji)
  bind_site(var.apps.browser, "T", var.websites.monkeytype)
  bind_site(var.apps.browser, "W", var.websites.wifi)

  hl.bind(var.mod .. " + B", hl.dsp.exec_cmd(var.apps.browser))
  hl.bind(var.mod .. " + SPACE", hl.dsp.exec_cmd(var.scripts.launcher))

  bind_exits()
end)

-- ============================================================================
-- DEVTOOLS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + D", function()
  enter_submap("Dev Tools", true)
end)

hl.define_submap("Dev Tools", "reset", function()
  bind_site(var.apps.browser, "G", var.websites.github)
  bind_site(var.apps.browser, "C", var.websites.cloudflare)
  bind_site(var.apps.browser, "R", var.websites.coderabbit)
  bind_site(var.apps.browser, "F", var.websites.figma)
  bind_site(var.apps.browser, "A", var.websites.arch)
  bind_site(var.apps.browser, "V", var.websites.vercel)
  bind_site(var.apps.browser, "D", var.websites.devdocs)
  bind_site(var.apps.browser, "W", var.websites.w3school)
  bind_site(var.apps.browser, "O", var.websites.google_cloud)
  bind_site(var.apps.browser, "E", var.websites.react_aria)
  bind_site(var.apps.browser, "H", var.websites.hl_wiki)
  bind_site(var.apps.browser, "Q", var.websites.qs_wiki)
  bind_site(var.apps.browser, "B", var.websites.backblaze)
  bind_site(var.apps.browser, "Z", var.websites.zig)
  bind_site(var.apps.browser, "L", var.websites.leetcode)
  bind_site(var.apps.browser, "X", var.websites.learnxinyminutes)

  bind_exits()
end)

-- ============================================================================
-- MEDIA SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + M", function()
  enter_submap("Media", true)
end)

hl.define_submap("Media", "reset", function()
  bind_site(var.apps.browser, "A", var.websites.annas_archive)
  bind_site(var.apps.browser, "Y", var.websites.youtube)
  bind_site(var.apps.browser, "F", var.websites.facebook)
  bind_site(var.apps.browser, "N", var.websites.news)
  bind_site(var.apps.browser, "S", var.websites.spotify)
  bind_site(var.apps.browser, "M", var.websites.ytmusic)
  bind_site(var.apps.browser, "V", var.websites.mappltv)
  bind_site(var.apps.browser, "G", var.websites.manga)
  bind_site(var.apps.browser, "I", var.websites.medium)

  bind_exits()
end)

-- ============================================================================
-- SCHOOL WORKS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + S", function()
  enter_submap("School", true)
end)

hl.define_submap("School", "reset", function()
  bind_site(var.apps.browser_school, "C", var.websites.classroom)
  bind_site(var.apps.browser_school, "M", var.websites.mail)
  bind_site(var.apps.browser_school, "O", var.websites.olsis)

  hl.bind(var.mod .. " + S", hl.dsp.exec_cmd(var.apps.browser_school))

  bind_exits()
end)

-- ============================================================================
-- UTILITIES SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + U", function()
  enter_submap("Util", false)
end)

hl.define_submap("Util", "reset", function()
  hl.bind("SHIFT + S", hl.dsp.exec_cmd(var.scripts.screenshotfull))
  hl.bind("S", hl.dsp.exec_cmd(var.scripts.screenshot))
  hl.bind("R", hl.dsp.exec_cmd(var.scripts.record))
  hl.bind("O", hl.dsp.exec_cmd(var.scripts.ocr))
  hl.bind("C", hl.dsp.exec_cmd(var.apps.colorpicker))
  hl.bind("E", eyetemp.toggle)

  hl.bind("Shift_L", hl.dsp.exec_cmd("true"))
  bind_exits()
end)

-- ============================================================================
-- RESIZE WINDOWS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + R", function()
  enter_submap("resize", false)
end)

hl.define_submap("resize", function()
  hl.bind("right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- MOUSE MODE SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + Q", function()
  enter_submap("Mouse Mode", false)
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

  -- Slow speed
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
  hl.bind("KP_End", mouse.toggle)

  hl.bind("Q", function()
    mouse.click("left")
  end)
  hl.bind("W", function()
    mouse.click("right")
  end)
  hl.bind("E", function()
    mouse.click("middle")
  end)
  hl.bind("R", mouse.toggle)

  hl.bind("escape", mouse.reset)
end)
