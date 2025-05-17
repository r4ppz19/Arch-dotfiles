#!/bin/bash

# Improved Battery Warning Script

# Note to self:
# Dependency: libnotify, acpid, acpi (anable the acpid service)
# sudo systemctl enable acpid.service
# sudo systemctl start acpid.service

# Create ACPI Event Configuration
# Create /etc/acpi/events/battery_notify with:
# event=ac_adapter
# action=/home/r4ppz/Arch-dotfiles/scripts/battery_warn.sh
# then restart acpid to apply changes
# sudo systemctl restart acpid.service

# 1. Battery Path Detection (Supports BAT0/BAT1)
BATTERY_PATH="/sys/class/power_supply"
for batt in BAT1 BAT0; do
    [[ -d "$BATTERY_PATH/$batt" ]] && {
        CAPACITY_FILE="$BATTERY_PATH/$batt/capacity"
        STATUS_FILE="$BATTERY_PATH/$batt/status"
        break
    }
done

[[ -f "$CAPACITY_FILE" && -f "$STATUS_FILE" ]] || {
    logger -t battery_warn "Battery files not found!"
    exit 1
}

# 2. State Management (Prevents Notification Spam)
CACHE_DIR="$HOME/.cache/battery_warnings"
mkdir -p "$CACHE_DIR"
STATE_FILE="$CACHE_DIR/last_state"

# 3. Notification Environment (Hyprland Compatibility)
export WAYLAND_DISPLAY="$(ls /run/user/$UID/wayland-* | head -n1)"
export XDG_RUNTIME_DIR="/run/user/$UID"

# 4. Main Logic with Threshold Hysteresis
BATTERY_LEVEL=$(<"$CAPACITY_FILE")
STATUS=$(<"$STATUS_FILE")
LAST_STATE=$(<"$STATE_FILE" 2>/dev/null)

case $STATUS in
    Discharging)
        if (( BATTERY_LEVEL <= 20 )) && [[ "$LAST_STATE" != "Low" ]]; then
            notify-send -u critical "Battery Low" "At ${BATTERY_LEVEL}% - Plug in!"
            echo "Low" > "$STATE_FILE"
        elif (( BATTERY_LEVEL > 25 )) && [[ "$LAST_STATE" == "Low" ]]; then
            echo "Normal" > "$STATE_FILE"  # Reset state when recovering
        fi
        ;;
    Charging|Full)
        if (( BATTERY_LEVEL >= 95 )) && [[ "$LAST_STATE" != "Full" ]]; then
            notify-send -u normal "Battery Full" "At ${BATTERY_LEVEL}% - Unplug!"
            echo "Full" > "$STATE_FILE"
        elif (( BATTERY_LEVEL < 90 )) && [[ "$LAST_STATE" == "Full" ]]; then
            echo "Normal" > "$STATE_FILE"  # Reset when below 90%
        fi
        ;;
esac
