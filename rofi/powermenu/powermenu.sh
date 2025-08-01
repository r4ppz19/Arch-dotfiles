#!/usr/bin/env bash

# Directories & Theme
dir="$HOME/.config/rofi/powermenu"
theme='main'

# Get system info
uptime="$(uptime -p | sed -e 's/up //g')"
host="$(cat /proc/sys/kernel/hostname)"

# Icons (Nerd Fonts)
shutdown='󰐥'
reboot='󰜉'
lock=''
suspend='󰤄'
hibernate='󰒲'
yes=''
no=''

# Rofi Command
rofi_cmd() {
  rofi -dmenu \
    -p "Uptime: $uptime" \
    -mesg "Uptime: $uptime" \
    -theme "${dir}/${theme}.rasi"
}

# Confirmation Dialog
confirm_cmd() {
  rofi -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you sure?' \
    -theme "${dir}/confirm.rasi"
}

# Ask for Confirmation
confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Show Rofi Menu
run_rofi() {
  echo -e "$lock\n$suspend\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Commands
run_cmd() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    case "$1" in
    '--shutdown') systemctl poweroff ;;
    '--reboot') systemctl reboot ;;
    '--suspend')
      mpc -q pause
      amixer set Master mute
      systemctl suspend
      ;;
    '--hibernate')
      mpc -q pause
      amixer set Master mute
      systemctl hibernate
      ;;
    esac
  else
    exit 0
  fi
}

# Handle User Selection
chosen="$(run_rofi)"
case "$chosen" in
"$shutdown") run_cmd --shutdown ;;
"$reboot") run_cmd --reboot ;;
"$lock") sleep 0.5 && swaylock ;;
"$suspend") run_cmd --suspend ;;
"$hibernate") run_cmd --hibernate ;;
esac
