#!/bin/bash

# Note to self:
# install ydotool
# run ydotoold in the background (use systemd)
# you must be in the input group to use ydotool properly

case "$1" in
left) /usr/bin/ydotool click 0x40 0x80 ;;
right) /usr/bin/ydotool click 0x41 0x81 ;;
middle) /usr/bin/ydotool click 0x42 0x82 ;;
toggle)
  STATE_FILE="/tmp/mouse_state"

  if [ ! -f "$STATE_FILE" ]; then
    echo "released" >"$STATE_FILE"
  fi

  CURRENT_STATE=$(cat "$STATE_FILE")

  if [ "$CURRENT_STATE" = "released" ]; then
    echo "pressed" >"$STATE_FILE"
    /usr/bin/ydotool click 0x40
    notify-send "Mouse: Pressed"
  else
    echo "released" >"$STATE_FILE"
    /usr/bin/ydotool click 0x80
    notify-send "Mouse: Released"
  fi
  ;;
esac
