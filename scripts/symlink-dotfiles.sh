#!/bin/bash

DOTFILES="$HOME/Arch-dotfiles"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

for item in btop hypr kitty lazygit neofetch nvim ranger rofi swaylock swaync systemd waybar yazi; do
  src="$DOTFILES/$item"
  dest="$CONFIG_DIR/$item"
  echo "Linking $src → $dest"
  ln -sf "$src" "$dest"
done

ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/zsh_plugins.txt" "$HOME/zsh_plugins.txt"
