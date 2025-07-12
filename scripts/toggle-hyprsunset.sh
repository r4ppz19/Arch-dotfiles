#!/bin/bash

STATE_FILE="$HOME/.cache/hyprsunset_mode"

[ ! -f "$STATE_FILE" ] && echo "day" > "$STATE_FILE"
MODE=$(cat "$STATE_FILE")

if [[ "$MODE" == "day" ]]; then
  echo "Switching to NIGHT mode..."
  hyprctl hyprsunset temperature 3800
  hyprctl hyprsunset gamma 90
  brightnessctl set 25%
  echo "night" > "$STATE_FILE"
else
  echo "Switching to DAY mode..."
  hyprctl hyprsunset temperature 5000
  hyprctl hyprsunset gamma 95
  brightnessctl set 50%
  echo "day" > "$STATE_FILE"
fi

