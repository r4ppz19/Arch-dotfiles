-- Floating dialog windows
hl.window_rule({
  name = "xdg-desktop-portal-gtk",
  match = { initial_class = "^.*(xdg-desktop-portal-gtk).*$" },
  pin = true,
  float = true,
  center = true,
  size = { 700, 500 },
})

hl.window_rule({
  name = "DesktopEditors",
  match = { initial_class = "^.*(DesktopEditors).*$" },
  pin = true,
  float = true,
  center = true,
  size = { 570, 120 },
})

hl.window_rule({
  name = "task and network managers",
  match = { initial_class = "taskmanager|network" },
  pin = true,
  float = true,
  center = true,
  size = { 1000, 700 },
})

hl.window_rule({
  name = "network/bluetooth-dialogs",
  match = { initial_class = "^.*(nm-connection-editor|blueman-manager|bluetuith|bluetooth).*$" },
  pin = true,
  float = true,
  center = true,
  size = { 800, 500 },
})

hl.window_rule({
  name = "common-dialogs",
  match = {
    initial_title = "^.*(Open File|Open Files|Save File|Open Folder|Choose Files|Choose Folder|Create Folder|Select Folder|Open Document|Save As).*$",
  },
  pin = true,
  float = true,
  center = true,
  size = { 700, 500 },
})

hl.window_rule({
  name = "file-ops",
  match = { initial_title = "^(Rename|Move|File Operation Progress).*$" },
  pin = true,
  float = true,
  center = true,
  size = { 350, 130 },
})

-- Web / specific popups
hl.window_rule({
  name = "export-download",
  match = { initial_title = "^.*(export-download|codeload|wants to).*$" },
  pin = true,
  float = true,
  center = true,
  size = { 700, 500 },
})

hl.window_rule({
  name = "tempai",
  match = { initial_class = "^brave-duck.ai__chat-Default$" },
  pin = true,
  float = true,
  center = true,
  size = { 800, 600 },
})

-- Workspace assignments
hl.window_rule({
  name = "brave-browser",
  match = { class = "brave-browser" },
  workspace = 1,
})

hl.window_rule({
  name = "brave-browser",
  match = { class = "brave-origin-nightly" },
  workspace = 1,
})

hl.window_rule({
  name = "helium",
  match = { class = "helium" },
  workspace = 5,
})

hl.window_rule({
  name = "musicplayer",
  match = { class = "musicplayer" },
  workspace = "special:window2",
})

hl.window_rule({
  name = "google-classroom",
  match = { initial_class = "^chrome-classroom.google.com__-Default$" },
  workspace = 5,
})

hl.window_rule({
  name = "youtube-music",
  match = { initial_class = "^brave-music.youtube.com__-Default$" },
  workspace = 4,
})

hl.window_rule({
  name = "obs",
  match = { initial_class = "^com.obsproject.Studio$" },
  workspace = 3,
})

hl.window_rule({
  name = "vscode",
  match = { initial_title = "^(Visual Studio Code)$" },
  workspace = 3,
})

hl.window_rule({
  name = "onlyoffice",
  match = { class = "ONLYOFFICE" },
  workspace = 3,
})

-- Code fullscreen
hl.window_rule({
  name = "code-fullscreen",
  match = { class = "Code" },
  fullscreen_state = 2,
})

-- Prevents screen idle/sleep
hl.window_rule({
  match = { initial_class = "brave-music.youtube.com__-Default" },
  idle_inhibit = "always",
})
hl.window_rule({
  match = { initial_class = "brave-www.youtube.com__-Default" },
  idle_inhibit = "focus",
})
