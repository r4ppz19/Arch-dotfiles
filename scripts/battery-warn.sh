#!/bin/bash
set -euo pipefail

# Configuration
LOW_BATTERY_THRESHOLD=30
CRITICAL_BATTERY_THRESHOLD=20
VERY_CRITICAL_THRESHOLD=10
CHECK_INTERVAL=15
LOG_FILE="$HOME/.local/share/battery_monitor.log"

LAST_NOTIFICATION_LEVEL=""
NOTIFICATION_COOLDOWN=300
LAST_NOTIFICATION_TIME=0

log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >>"$LOG_FILE"
}

send_notification() {
  local urgency="$1"
  local title="$2"
  local message="$3"
  local current_time=$(date +%s)

  if [[ "$LAST_NOTIFICATION_LEVEL" == "$urgency" ]]; then
    local time_diff=$((current_time - LAST_NOTIFICATION_TIME))
    if [[ $time_diff -lt $NOTIFICATION_COOLDOWN ]]; then
      return
    fi
  fi

  notify-send -u "$urgency" -t 10000 -a "Battery Monitor" \
    -h boolean:transient:true "$title" "$message"
  log_message "Notification sent: $title - $message"

  LAST_NOTIFICATION_LEVEL="$urgency"
  LAST_NOTIFICATION_TIME=$current_time
}

get_battery_icon() {
  local level="$1"
  local status="$2"

  if [[ "$status" == "Charging" ]]; then
    echo "󰂄"
  elif ((level >= 90)); then
    echo "󰁹"
  elif ((level >= 80)); then
    echo "󰂂"
  elif ((level >= 60)); then
    echo "󰂀"
  elif ((level >= 40)); then
    echo "󰁾"
  elif ((level >= 20)); then
    echo "󰁼"
  elif ((level >= 10)); then
    echo "󰁺"
  else
    echo "󰂎"
  fi
}

get_battery_info() {
  local bat_path="/sys/class/power_supply"
  local battery_dir=""

  for bat in "$bat_path"/BAT*; do
    if [[ -d "$bat" ]]; then
      battery_dir="$bat"
      break
    fi
  done

  if [[ -z "$battery_dir" ]]; then
    log_message "ERROR: No battery found in $bat_path"
    exit 1
  fi

  if [[ -r "$battery_dir/capacity" && -r "$battery_dir/status" ]]; then
    battery_level=$(cat "$battery_dir/capacity")
    charging_status=$(cat "$battery_dir/status")
  else
    log_message "ERROR: Cannot read battery information from $battery_dir"
    exit 1
  fi
}

main() {
  log_message "Battery monitor started (PID: $$)"

  while true; do
    get_battery_info
    local battery_icon=$(get_battery_icon "$battery_level" "$charging_status")

    if [[ "$charging_status" != "Charging" ]]; then
      if ((battery_level <= VERY_CRITICAL_THRESHOLD)); then
        send_notification "critical" "󰂎 CRITICAL BATTERY" \
          "Battery at ${battery_level}%! System will shutdown soon. 󱐋 PLUG IN NOW!"
      elif ((battery_level <= CRITICAL_BATTERY_THRESHOLD)); then
        send_notification "critical" "󰁺 CRITICAL BATTERY" \
          "Battery at ${battery_level}%. 󱐋 Plug in immediately!"
      elif ((battery_level <= LOW_BATTERY_THRESHOLD)); then
        send_notification "normal" "${battery_icon} Low Battery" \
          "Battery at ${battery_level}%. 󱐋 Please charge soon."
      fi
    else
      LAST_NOTIFICATION_LEVEL=""
    fi

    sleep $CHECK_INTERVAL
  done
}

cleanup() {
  log_message "Battery monitor stopped"
  exit 0
}

trap cleanup SIGTERM SIGINT

mkdir -p "$(dirname "$LOG_FILE")"

main
