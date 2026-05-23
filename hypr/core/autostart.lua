hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprland.target")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
end)

hl.on("hyprland.shutdown", function()
  hl.exec_cmd("systemctl --user stop hyprland.target")
end)
