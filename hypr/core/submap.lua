local var = require("util.variable")
local mouse = require("util.mouse")
local eyetemp = require("util.eyetemp")
local notify = require("util.notify")
local zen = require("util.zen")

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

  drive = "https://drive.google.com/drive/my-drive",
  mail = "https://mail.google.com",
  getemoji = "https://getemoji.com",
  monkeytype = "https://monkeytype.com",
  wifi = "http://192.168.1.254",

  classroom = "https://classroom.google.com",
  olsis = "https://tsis.assumptiondavao.edu.ph",

  annas_archive = "https://annas-archive.is",
  reddit = "https://www.reddit.com",
  youtube = "https://www.youtube.com",
  facebook = "https://www.facebook.com/messages",
  news = "https://news.ycombinator.com",
  spotify = "https://open.spotify.com",
  ytmusic = "https://music.youtube.com",
  mappltv = "https://mappl.tv",
  twitter = "https://x.com/",
  manga = "https://mangakatana.com",
  medium = "https://medium.com",
  discord = "https://discord.com/channels/@me",

  codeberg = "https://codeberg.org/r4ppz",
  github = "https://github.com/r4ppz",
  devdocs = "https://devdocs.io",
  arch = "https://archlinux.org",
  render = "https://dashboard.render.com",
  figma = "https://www.figma.com",
  vercel = "https://vercel.com/r4ppz",
  cloudflare = "https://dash.cloudflare.com",
  w3school = "https://www.w3schools.com",
  google_cloud = "https://console.cloud.google.com/apis",
  react_aria = "https://react-aria.adobe.com/getting-started",
  hl_wiki = "https://wiki.hypr.land",
  qs_wiki = "https://quickshell.org/docs/v0.3.0/guide/introduction/",
}

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
  bind_site(var.browser, "V", websites.microsoft_copilot)
  bind_site(var.browser, "K", websites.kimi)
  bind_site(var.browser, "X", websites.github_copilot)
  bind_site(var.browser, "C", websites.chatgpt)
  bind_site(var.browser, "P", websites.perplexity)
  bind_site(var.browser, "G", websites.gemini)
  bind_site(var.browser, "D", websites.deepseek)
  bind_site(var.browser, "N", websites.notebooklm)
  bind_site(var.browser, "Q", websites.qwen)
  bind_site(var.browser, "H", websites.huggingface)
  bind_site(var.browser, "O", websites.duckduckgo)
  bind_site(var.browser, "M", websites.mistral)
  bind_site(var.browser, "A", websites.claude)

  bind_exits()
end)

-- ============================================================================
-- APPLICATIONS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + SPACE", function()
  enter_submap("Applications", true)
end)

hl.define_submap("Applications", "reset", function()
  bind_site(var.browser, "D", websites.drive)
  bind_site(var.browser, "M", websites.mail)
  bind_site(var.browser, "E", websites.getemoji)
  bind_site(var.browser, "T", websites.monkeytype)
  bind_site(var.browser, "W", websites.wifi)

  hl.bind(var.mod .. " + B", hl.dsp.exec_cmd(var.browser))
  hl.bind(var.mod .. " + SPACE", hl.dsp.exec_cmd(var.launcher))

  bind_exits()
end)

-- ============================================================================
-- DEVTOOLS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + D", function()
  enter_submap("Dev Tools", true)
end)

hl.define_submap("Dev Tools", "reset", function()
  bind_site(var.browser, "G", websites.github)
  bind_site(var.browser, "C", websites.cloudflare)
  bind_site(var.browser, "R", websites.render)
  bind_site(var.browser, "F", websites.figma)
  bind_site(var.browser, "A", websites.arch)
  bind_site(var.browser, "V", websites.vercel)
  bind_site(var.browser, "D", websites.devdocs)
  bind_site(var.browser, "W", websites.w3school)
  bind_site(var.browser, "O", websites.google_cloud)
  bind_site(var.browser, "E", websites.react_aria)
  bind_site(var.browser, "H", websites.hl_wiki)
  bind_site(var.browser, "Q", websites.qs_wiki)
  bind_site(var.browser, "B", websites.codeberg)

  bind_exits()
end)

-- ============================================================================
-- MEDIA SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + M", function()
  enter_submap("Media", true)
end)

hl.define_submap("Media", "reset", function()
  bind_site(var.browser, "A", websites.annas_archive)
  bind_site(var.browser, "Y", websites.youtube)
  bind_site(var.browser, "R", websites.reddit)
  bind_site(var.browser, "F", websites.facebook)
  bind_site(var.browser, "N", websites.news)
  bind_site(var.browser, "S", websites.spotify)
  bind_site(var.browser, "M", websites.ytmusic)
  bind_site(var.browser, "X", websites.twitter)
  bind_site(var.browser, "V", websites.mappltv)
  bind_site(var.browser, "G", websites.manga)
  bind_site(var.browser, "I", websites.medium)
  bind_site(var.browser, "D", websites.discord)

  bind_exits()
end)

-- ============================================================================
-- SCHOOL WORKS SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + S", function()
  enter_submap("School", true)
end)

hl.define_submap("School", "reset", function()
  bind_site(var.school_browser, "C", websites.classroom)
  bind_site(var.school_browser, "M", websites.mail)
  bind_site(var.school_browser, "O", websites.olsis)

  hl.bind(var.mod .. " + S", hl.dsp.exec_cmd(var.school_browser))

  bind_exits()
end)

-- ============================================================================
-- UTILITIES SUBMAP
-- ============================================================================
hl.bind(var.mod .. " + U", function()
  enter_submap("Util", false)
end)

hl.define_submap("Util", "reset", function()
  hl.bind("SHIFT + S", hl.dsp.exec_cmd(var.screenshotfull))
  hl.bind("S", hl.dsp.exec_cmd(var.screenshot))
  hl.bind("R", hl.dsp.exec_cmd(var.record))
  hl.bind("O", hl.dsp.exec_cmd(var.ocr))
  hl.bind("C", hl.dsp.exec_cmd(var.colorpicker))
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
