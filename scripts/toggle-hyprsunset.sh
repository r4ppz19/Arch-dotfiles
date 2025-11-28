#!/bin/bash
set -euo pipefail

STATE_FILE="$HOME/.cache/hyprsunset_mode"

if [[ ! -f "$STATE_FILE" ]]; then
  echo "day" >"$STATE_FILE"
fi

read -r MODE <"$STATE_FILE"

case "$MODE" in
day)
  hyprctl hyprsunset temperature 3800
  hyprctl hyprsunset gamma 90
  notify-send -t 1000 -h boolean:transient:true \
    -a "Toggle HyprSunset" "NIGHT MODE" -i dialog-information
  echo "night" >"$STATE_FILE"
  ;;

night)
  hyprctl hyprsunset temperature 4500
  hyprctl hyprsunset gamma 100
  notify-send -t 1000 -h boolean:transient:true \
    -a "Toggle HyprSunset" "READING MODE" -i dialog-information
  echo "reading" >"$STATE_FILE"
  ;;

reading)
  hyprctl hyprsunset temperature 5000
  hyprctl hyprsunset gamma 100
  notify-send -t 1000 -h boolean:transient:true \
    -a "Toggle HyprSunset" "DAY MODE" -i dialog-information
  echo "day" >"$STATE_FILE"
  ;;

*)
  echo "Unknown mode: '$MODE'. Resetting state to 'day'."
  hyprctl hyprsunset temperature 5000
  hyprctl hyprsunset gamma 100
  echo "day" >"$STATE_FILE"
  ;;
esac
