local function floating_rule(opts)
  opts.pin = opts.pin ~= false and true or opts.pin
  opts.float = opts.float ~= false and true or opts.float
  opts.center = opts.center ~= false and true or opts.center

  hl.window_rule(opts)
end

local function workspace_rule(name, match, workspace)
  hl.window_rule({
    name = name,
    match = match,
    workspace = workspace,
  })
end

-- Floating dialog windows
floating_rule({
  name = "xdg-desktop-portal-gtk",
  match = {
    initial_class = "^.*(xdg-desktop-portal-gtk).*$",
  },
  size = { 700, 500 },
})

floating_rule({
  name = "DesktopEditors",
  match = {
    initial_class = "^.*(DesktopEditors).*$",
  },
  size = { 570, 120 },
})

floating_rule({
  name = "common-dialogs",
  match = {
    initial_title = "^.*(Open File|Open Files|Save File|Open Folder|Choose Files|Choose Folder|Create Folder|Select Folder|Open Document|Save As).*$",
  },
  size = { 700, 500 },
})

floating_rule({
  name = "file-ops",
  match = {
    initial_title = "^(Rename|Move|File Operation Progress).*$",
  },
  size = { 350, 130 },
})

-- Web / specific popups
floating_rule({
  name = "export-download",
  match = {
    initial_title = "^.*(export-download|codeload|wants to).*$",
    modal = true,
  },
  size = { 700, 500 },
})

floating_rule({
  name = "task, network and bluetooth managers",
  match = { initial_class = "taskmanager|network|bluetooth" },
  size = { 1000, 700 },
})

floating_rule({
  name = "gsimplecal",
  match = { class = "gsimplecal" },
})

floating_rule({
  name = "bluetooth-dialogs-gui",
  match = {
    initial_class = "^.*(nm-connection-editor|blueman-manager).*$",
  },
  size = { 800, 500 },
})

floating_rule({
  name = "bitwarden",
  match = { initial_class = "Bitwarden" },
  size = { 1000, 700 },
})

floating_rule({
  name = "tempai",
  match = {
    initial_class = "^brave-duck.ai__chat-Default|brave-chatgpt.com__-Default$",
  },
  size = { 800, 600 },
})

-- Workspace assignments
workspace_rule("brave-browser", { class = "brave-browser" }, 1)
workspace_rule("brave-browser", { class = "brave-origin-nightly" }, 1)
workspace_rule("helium", { class = "helium" }, 5)
workspace_rule("musicplayer", { class = "musicplayer" }, "special:window2")
workspace_rule("google-classroom", { initial_class = "^chrome-classroom.google.com__-Default$" }, 5)
workspace_rule("youtube-music", { initial_class = "^brave-music.youtube.com__-Default$" }, 4)
workspace_rule("obs", { initial_class = "^com.obsproject.Studio$" }, 3)
workspace_rule("vscode", { initial_title = "^(Visual Studio Code)$" }, 3)
workspace_rule("onlyoffice", { class = "ONLYOFFICE" }, 3)

-- Code fullscreen
hl.window_rule({
  name = "code-fullscreen",
  match = { class = "Code" },
  fullscreen_state = 2,
})

-- Prevent screen idle/sleep
hl.window_rule({
  match = {
    initial_class = "brave-music.youtube.com__-Default",
  },
  idle_inhibit = "always",
})

hl.window_rule({
  match = {
    initial_class = "brave-www.youtube.com__-Default|musicplayer",
  },
  idle_inhibit = "focus",
})
