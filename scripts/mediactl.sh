#!/bin/bash

set -euo pipefail

# ============================================================
# Media + Brightness Control Script
#
# Supports:
# - PipeWire volume/mute
# - Microphone mute
# - Laptop brightness via brightnessctl
# - External monitor brightness via ddcutil
#

# Config
VOLUME_STEP=5
BRIGHTNESS_STEP=5

DDCUTIL_ARGS="--sleep-multiplier=.1"

notify() {
  local category="$1"
  local title="$2"
  local message="$3"
  local icon="$4"

  notify-send \
    -h string:x-canonical-private-synchronous:"$category" \
    -h boolean:transient:true \
    -t 1000 \
    "$title" \
    "$message" \
    -i "$icon"
}

# Helpers
get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ |
    awk '{printf "%.0f%%", $2 * 100}'
}

get_audio_state() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ |
    awk '{if ($3 == "[MUTED]") print "Muted"; else print "Unmuted"}'
}

get_mic_state() {
  wpctl get-volume @DEFAULT_AUDIO_SOURCE@ |
    awk '{if ($3 == "[MUTED]") print "Muted"; else print "Unmuted"}'
}

has_external_monitor() {
  ddcutil detect 2>/dev/null | grep -q "Display 1"
}

get_external_brightness() {
  ddcutil getvcp 10 --brief 2>/dev/null | awk '{print $4}'
}

set_external_brightness() {
  local value="$1"

  ddcutil $DDCUTIL_ARGS setvcp 10 "$value" >/dev/null
}

get_laptop_brightness() {
  brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
}

set_laptop_brightness() {
  local direction="$1"

  case "$direction" in
  up)
    brightnessctl set "${BRIGHTNESS_STEP}%+" >/dev/null
    ;;
  down)
    brightnessctl set "${BRIGHTNESS_STEP}%-" >/dev/null
    ;;
  esac
}

clamp() {
  local value="$1"
  local min="$2"
  local max="$3"

  ((value < min)) && value=$min
  ((value > max)) && value=$max

  echo "$value"
}

# Actions
volume_up() {
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "${VOLUME_STEP}%+"

  notify \
    "volume" \
    "Volume" \
    "$(get_volume)" \
    "audio-volume-high-symbolic"
}

volume_down() {
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "${VOLUME_STEP}%-"

  notify \
    "volume" \
    "Volume" \
    "$(get_volume)" \
    "audio-volume-low-symbolic"
}

mute_audio() {
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

  notify \
    "audio" \
    "Audio" \
    "$(get_audio_state)" \
    "audio-volume-muted-symbolic"
}

mute_mic() {
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

  notify \
    "mic" \
    "Microphone" \
    "$(get_mic_state)" \
    "microphone-sensitivity-muted-symbolic"
}

brightness_up() {
  if has_external_monitor; then
    local current
    local new

    current=$(get_external_brightness)
    new=$((current + BRIGHTNESS_STEP))
    new=$(clamp "$new" 0 100)

    set_external_brightness "$new"

    notify \
      "brightness" \
      "External Brightness" \
      "${new}%" \
      "display-brightness-high-symbolic"
  else
    set_laptop_brightness up

    notify \
      "brightness" \
      "Laptop Brightness" \
      "$(get_laptop_brightness)%" \
      "display-brightness-high-symbolic"
  fi
}

brightness_down() {
  if has_external_monitor; then
    local current
    local new

    current=$(get_external_brightness)
    new=$((current - BRIGHTNESS_STEP))
    new=$(clamp "$new" 0 100)

    set_external_brightness "$new"

    notify \
      "brightness" \
      "External Brightness" \
      "${new}%" \
      "display-brightness-low-symbolic"
  else
    set_laptop_brightness down

    notify \
      "brightness" \
      "Laptop Brightness" \
      "$(get_laptop_brightness)%" \
      "display-brightness-low-symbolic"
  fi
}

# Dispatcher
case "${1:-}" in
volume-up)
  volume_up
  ;;
volume-down)
  volume_down
  ;;
mute)
  mute_audio
  ;;
mic-mute)
  mute_mic
  ;;
brightness-up)
  brightness_up
  ;;
brightness-down)
  brightness_down
  ;;
*)
  echo "Usage:"
  echo "  $0 volume-up"
  echo "  $0 volume-down"
  echo "  $0 mute"
  echo "  $0 mic-mute"
  echo "  $0 brightness-up"
  echo "  $0 brightness-down"
  exit 1
  ;;
esac
