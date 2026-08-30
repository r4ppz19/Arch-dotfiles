# Install Guide

This is a minimal installation guide, assuming you just installed Arch Linux and Hyprland using archinstall. This won’t recreate my current setup 1:1 (idk how to do that?! lol maybe I should just use Nix orwhatever). It’s just enough to make the system usable.

---

## System Update & Base Packages

```bash
sudo pacman -Syu --needed base-devel git
```

---

## Install yay (AUR Helper)

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
```

---

## Install Missing Official Repository Packages

```bash
yay -S --needed \
  # Hyprland extras
  hypridle hyprpaper hyprsunset hyprpolkitagent \
  # CLI Tools
  btop fastfetch lazygit yazi neovim \
  git git-delta github-cli \
  gdu-bin lazydocker opencode pgcli atuin \
  # Shell & Utilities
  zsh tmux fzf zoxide ripgrep fd eza bat \
  # Fonts
  ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-hack-nerd noto-fonts-emoji \
  # Audio
  pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
  # Bluetooth & Network
  blueman network-manager-applet \
  # Wayland Utilities
  grim slurp wl-clipboard wl-clip-persist brightnessctl \
  # Theming (Qt/GTK)
  kvantum qt5ct qt6ct nwg-look gtk-engine-murrine \
  # Media & Script Dependencies
  yt-dlp tesseract tesseract-data-eng \
  obs-studio docker docker-compose postgresql \
  thunar thunar-archive-plugin thunar-volman \
  # Script Runtime Dependencies
  libnotify curl playerctl kdeconnect
```

---

## Install AUR Packages

```bash
yay -S --needed \
  waybar-git \
  gruvbox-material-gtk-theme-git \
  gruvbox-plus-icon-theme-git \
  ttf-ms-win11-auto
```

Or just install everything in [pkglist.txt](pkglist.txt):

```bash
yay -S --needed - < pkglist.txt
```

---

## Switch to Zsh

Switch your default shell from bash to zsh:

```bash
chsh -s $(which zsh)
```

Log out and log back in (or reboot) for the change to take effect.

---

## Install Antidote (Zsh Plugin Manager)

```bash
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
```

---

## Clone & Link Dotfiles

```bash
git clone https://github.com/r4ppz/Arch-dotfiles.git ~/Arch-dotfiles
cd ~/Arch-dotfiles
git submodule update --init --recursive
chmod +x scripts/symlink-dotfiles.sh
./scripts/symlink-dotfiles.sh
```

---

## Initialize Zsh & Plugins

```bash
# Configure Powerlevel10k prompt
p10k configure
```

Plugins installed (from `zsh/.zsh_plugins.txt`):

- romkatv/powerlevel10k
- Aloxaf/fzf-tab
- zsh-users/zsh-autosuggestions
- zsh-users/zsh-completions
- zsh-users/zsh-syntax-highlighting
- r4ppz/git-open

---

## Enable Systemd User Services

All services in `systemd/user/` are linked to `~/.config/systemd/user/`.

```bash
systemctl --user daemon-reload

# Core Hyprland target (auto-starts on graphical session)
systemctl --user enable hyprland.target

# Services pulled in by hyprland.target
systemctl --user enable \
  waybar.service \
  swaync.service \
  hypridle.service \
  hyprpaper.service \
  hyprsunset.service \
  hyprpolkitagent.service \
  nm-applet.service \
  blueman-applet.service \
  ydotoold.service \
  battery-monitor.service

# Override configs (already linked via systemd/ dir)
# hypridle.service.d/override.conf
# hyprpolkitagent.service.d/override.conf
# waybar.service.d/override.conf
# swaync.service.d/override.conf
# hyprpaper.service.d/override.conf
# hyprsunset.service.d/override.conf

# Start now or Reboot
systemctl --user start hyprland.target
```

Verify:

```bash
systemctl --user status hyprland.target
systemctl --user list-units --state=active | grep -E 'waybar|swaync|hypr|nm-applet|blueman|ydotool|battery'
```

---

## Apply GTK / Qt Theming

Install all themes:

- GTK: [gruvbox-material-gtk](https://github.com/TheGreatMcPain/gruvbox-material-gtk)
- QT: [gruvbox-kvantum-themes](https://github.com/sachnr/gruvbox-kvantum-themes)
- Icon: [gruvbox-plus-icon-pack](https://github.com/SylEleuth/gruvbox-plus-icon-pack)

### GTK

```bash
# Via nwg-look (GUI) or manually:
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Material-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Plus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Hackneyed-24px'
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 10'
```

### Qt (Kvantum)

```bash
# Via nwg-look (GUI)
kvantummanager
qt6ct
qt5ct
```

---

## Fontconfig & Cache

```bash
fc-cache -fv
```
