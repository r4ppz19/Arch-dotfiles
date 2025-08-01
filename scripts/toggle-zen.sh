#!/bin/bash
set -euo pipefail

STATE="$HOME/.cache/hypr-zen-mode"

MONITOR="eDP-1"

NORMAL_GAPS_OUTER=15
NORMAL_GAPS_INNER=8
NORMAL_BORDER_SIZE=2
NORMAL_ROUNDING=1
NORMAL_ROUNDING_POWER=5
NORMAL_WALLPAPER="$HOME/Arch-dotfiles/wallpaper/wallpaper1.png"

ZEN_GAPS_OUTER=0
ZEN_GAPS_INNER=1
ZEN_BORDER_SIZE=0
ZEN_ROUNDING=0
ZEN_ROUNDING_POWER=0
ZEN_WALLPAPER="$HOME/Arch-dotfiles/wallpaper/plain-wallpaper.png"

set_hyprland() {
  hyprctl --batch "keyword general:gaps_out $1; \
                   keyword general:gaps_in $2; \
                   keyword general:border_size $3; \
                   keyword decoration:rounding $4; \
                   keyword decoration:rounding_power $5"
}

set_wallpaper() {
  local WALLPAPER="$1"
  hyprctl hyprpaper preload "$WALLPAPER"
  hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"
}

if [[ -f "$STATE" ]]; then
  set_hyprland "$NORMAL_GAPS_OUTER" "$NORMAL_GAPS_INNER" "$NORMAL_BORDER_SIZE" "$NORMAL_ROUNDING" "$NORMAL_ROUNDING_POWER"
  set_wallpaper "$NORMAL_WALLPAPER"
  systemctl --user start waybar.service
  rm -f "$STATE"
else
  set_hyprland "$ZEN_GAPS_OUTER" "$ZEN_GAPS_INNER" "$ZEN_BORDER_SIZE" "$ZEN_ROUNDING" "$ZEN_ROUNDING_POWER"
  set_wallpaper "$ZEN_WALLPAPER"
  systemctl --user stop waybar.service
  touch "$STATE"
fi

