# Using uwsm
# if [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ] && [ "$(tty)" = "/dev/tty1" ]; then
#   if uwsm check may-start; then
#     exec uwsm start hyprland.desktop
#   fi
# fi

# if [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ] && [ "$(tty)" = "/dev/tty1" ]; then
#   if uwsm check may-start && uwsm select; then
#     exec uwsm start default
#   fi
# fi

# Without uwsm
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec start-hyprland
fi
