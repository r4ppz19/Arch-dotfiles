#!/bin/bash

DOTFILES="$HOME/Arch-dotfiles"
CONFIG_DIR="$HOME/.config"

# Ensure .config directory exists
mkdir -p "$CONFIG_DIR"

# Symlink config folders
for item in btop hypr kitty lazygit neofetch nvim ranger rofi swaylock swaync systemd waybar yazi; do
    src="$DOTFILES/$item"
    dest="$CONFIG_DIR/$item"
    echo "Linking $src → $dest"
    ln -sf "$src" "$dest"
done

# Symlink top-level dotfiles
echo "Linking $DOTFILES/tmux/.tmux.conf → $HOME/.tmux.conf"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "Linking $DOTFILES/zsh/.zshrc → $HOME/.zshrc"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

echo "Linking $DOTFILES/zsh/zsh_plugins.txt → $HOME/zsh_plugins.txt"
ln -sf "$DOTFILES/zsh/zsh_plugins.txt" "$HOME/zsh_plugins.txt"
