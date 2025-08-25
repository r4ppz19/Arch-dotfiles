#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/Arch-dotfiles"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

CONFIG_ITEMS=(
  btop
  hypr
  kitty
  lazygit
  neofetch
  nvim
  ranger
  rofi
  swaylock
  swaync
  systemd
  waybar
  yazi
  uwsm
)

for item in "${CONFIG_ITEMS[@]}"; do
  src="$DOTFILES/$item"
  dest="$CONFIG_DIR/$item"

  if [[ -e "$src" ]]; then
    echo "Linking $src to $dest"
    ln -sfT "$src" "$dest"
  else
    echo "Skipping missing item: $src" >&2
  fi
done

[[ -e "$DOTFILES/tmux/.tmux.conf" ]] && ln -sfT "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
[[ -e "$DOTFILES/zsh/.zshrc" ]] && ln -sfT "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
[[ -e "$DOTFILES/zsh/zsh_plugins.txt" ]] && ln -sfT "$DOTFILES/zsh/zsh_plugins.txt" "$HOME/zsh_plugins.txt"
[[ -e "$DOTFILES/git/.gitconfig" ]] && ln -sfT "$DOTFILES/git/.giconfig" "$HOME/.gitconfig"

