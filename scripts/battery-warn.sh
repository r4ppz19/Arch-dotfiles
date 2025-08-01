#!/bin/bash
set -euo pipefail

# Configuration
LOW_BATTERY_THRESHOLD=30
CRITICAL_BATTERY_THRESHOLD=20
VERY_CRITICAL_THRESHOLD=10
CHECK_INTERVAL=30
LOG_FILE="$HOME/.local/share/battery_monitor.log"

# Notification tracking to avoid spam
LAST_NOTIFICATION_LEVEL=""
NOTIFICATION_COOLDOWN=300 # 5 minutes between same-level notifications
LAST_NOTIFICATION_TIME=0

# Logging function
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >>"$LOG_FILE"
}

# Send notification with cooldown
send_notification() {
  local urgency="$1"
  local title="$2"
  local message="$3"
  local current_time=$(date +%s)

  # Check if we should send notification (avoid spam)
  if [[ "$LAST_NOTIFICATION_LEVEL" == "$urgency" ]]; then
    local time_diff=$((current_time - LAST_NOTIFICATION_TIME))
    if [[ $time_diff -lt $NOTIFICATION_COOLDOWN ]]; then
      return
    fi
  fi

  # Send notification with timeout and app name for better integration
  notify-send -u "$urgency" -t 10000 -a "Battery Monitor" \
    -h boolean:transient:true \
    "$title" "$message"
  log_message "Notification sent: $title - $message"

  LAST_NOTIFICATION_LEVEL="$urgency"
  LAST_NOTIFICATION_TIME=$current_time
}

# Get battery icon based on level and status
get_battery_icon() {
  local level="$1"
  local status="$2"

  if [[ "$status" == "Charging" ]]; then
    echo "󰂄" # Battery charging icon
  elif ((level >= 90)); then
    echo "󰁹" # Battery full
  elif ((level >= 80)); then
    echo "󰂂" # Battery 4/5
  elif ((level >= 60)); then
    echo "󰂀" # Battery 3/5
  elif ((level >= 40)); then
    echo "󰁾" # Battery 2/5
  elif ((level >= 20)); then
    echo "󰁼" # Battery 1/5
  elif ((level >= 10)); then
    echo "󰁺" # Battery low
  else
    echo "󰂎" # Battery critical/empty
  fi
}

# Get battery info with error handling
get_battery_info() {
  local bat_path="/sys/class/power_supply"
  local battery_dir=""

  # Find battery directory (BAT0, BAT1, etc.)
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

  # Read battery info
  if [[ -r "$battery_dir/capacity" && -r "$battery_dir/status" ]]; then
    battery_level=$(cat "$battery_dir/capacity")
    charging_status=$(cat "$battery_dir/status")
  else
    log_message "ERROR: Cannot read battery information from $battery_dir"
    exit 1
  fi
}

# Main monitoring loop
main() {
  log_message "Battery monitor started (PID: $$)"

  while true; do
    get_battery_info
    local battery_icon=$(get_battery_icon "$battery_level" "$charging_status")

    # Only check when not charging
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
      # Reset notification tracking when charging
      LAST_NOTIFICATION_LEVEL=""
    fi

    sleep $CHECK_INTERVAL
  done
}

# Handle signals gracefully
cleanup() {
  log_message "Battery monitor stopped"
  exit 0
}

trap cleanup SIGTERM SIGINT

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Start monitoring
main
