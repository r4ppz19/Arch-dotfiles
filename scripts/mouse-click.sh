#!/bin/bash
set -euo pipefail

STATE_FILE="/tmp/mouse_state"

# Initialize state file if missing
if [[ ! -f "$STATE_FILE" ]]; then
  echo "released" >"$STATE_FILE"
fi

if [[ "$1" = "left" ]]; then
  ydotool click 0x40 0x80
  hyprctl dispatch submap reset

elif [[ "$1" = "right" ]]; then
  ydotool click 0x41 0x81

elif [[ "$1" = "middle" ]]; then
  ydotool click 0x42 0x82

elif [[ "$1" = "toggle" ]]; then
  CURRENT_STATE=$(cat "$STATE_FILE")

  if [[ "$CURRENT_STATE" = "released" ]]; then
    # Start Pressing
    echo "pressed" >"$STATE_FILE"
    ydotool click 0x40

  else
    # End Pressing & Copy
    echo "released" >"$STATE_FILE"
    ydotool click 0x80

    sleep 0.1
    # Ctrl+C (copy selected text)
    ydotool key 29:1 46:1 46:0 29:0
    sleep 0.1

    # Click (clear selection)
    ydotool click 0x40 0x80

    notify-send -h boolean:transient:true \
      "Copied." \
      -i dialog-information \
      -t 1400

    hyprctl dispatch submap reset
  fi

elif [[ "$1" = "reset" ]]; then
  echo "released" >"$STATE_FILE"

  ydotool click 0x80
  # ydotool click 0x40 0x80
  # ydotool key 1:1 1:0

  hyprctl dispatch submap reset
fi
