# Launch Hyprland with uwsm
# if uwsm check may-start && uwsm select; then
# 	exec uwsm start default
# fi
#

# Bypass compositor selection menu
# Skip compositor start if inside tmux
if [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ] && [ "$(tty)" = "/dev/tty1" ]; then
  if uwsm check may-start; then
    exec uwsm start hyprland.desktop
  fi
fi
