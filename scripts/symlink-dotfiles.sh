#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/Arch-dotfiles"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

CONFIG_LINKS=(
  btop
  hypr
  kitty
  lazygit
  nvim
  rofi
  swaylock
  swaync
  systemd
  waybar
  yazi
  fastfetch
  pacseek
  gdu
  lazydocker
  opencode
  pgcli
)

link_item() {
  local src="$1"
  local dest="$2"
  if [[ -e "$src" ]]; then
    echo "Linking $src to $dest"
    ln -sfT "$src" "$dest"
  else
    echo "Skipping missing item: $src" >&2
  fi
}

for item in "${CONFIG_LINKS[@]}"; do
  link_item "$DOTFILES_DIR/$item" "$CONFIG_DIR/$item"
done

link_item "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
link_item "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_item "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_item "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_item "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_item "$DOTFILES_DIR/zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
link_item "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
