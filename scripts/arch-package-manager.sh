#!/bin/bash

if ! command -v gum &>/dev/null; then
  echo "Error: 'gum' is required but not installed. Please install it first." >&2
  exit 1
fi

: "${EDITOR:=code}"

# Gruvbox color palette
GB_DARK0="#282828"
GB_DARK1="#504945"
GB_FG_WHITE="#ebdbb2"
GB_FG_YELLOW="#fabd2f"
GB_FG_BLUE="#83a598"
GB_FG_RED="#fb4934"
GB_FG_AQUA="#8ec07c"

log_header() {
  gum style --border normal --border-foreground "$GB_FG_BLUE" --padding "0 2" --margin "1 0" --bold -- "$1"
}

log_info() {
  gum style --foreground "$GB_FG_BLUE" -- "$1"
}

log_success() {
  gum style --foreground "$GB_FG_AQUA" -- "$1"
}

log_warn() {
  gum style --foreground "$GB_FG_YELLOW" -- "$1"
}

log_error() {
  gum style --foreground "$GB_FG_RED" -- "Error: $1" >&2
}

print_usage() {
  gum style --foreground "$GB_FG_BLUE" -- "Usage: $0 <install|remove|pkgbuild> <package...>"
}

gum_confirm() {
  gum confirm \
    --prompt.foreground "$GB_FG_BLUE" \
    --selected.foreground "$GB_DARK0" \
    --selected.background "$GB_FG_BLUE" \
    --unselected.foreground "$GB_FG_WHITE" \
    --unselected.background "$GB_DARK0" \
    "$@"
}

gum_spin() {
  gum spin \
    --spinner.foreground "$GB_FG_YELLOW" \
    --title.foreground "$GB_FG_BLUE" \
    "$@"
}

print_summary() {
  local -n arr=$1
  local label=$2
  local color=$3

  ((${#arr[@]} == 0)) && return

  local joined="${arr[*]}"
  gum style --foreground "$color" -- "$label (${#arr[@]}): $joined"
}

# =============================================================================
# ACTION FUNCTIONS
# =============================================================================

do_install() {
  local not_found_pkgs=()
  local installed_pkgs=()
  local skipped_pkgs=()
  local error_pkgs=()

  if (($# > 1)); then
    log_header "Checking packages..."

    local valid_pkgs=()
    for pkg in "$@"; do
      if gum_spin --spinner dot --title "Checking $pkg..." -- pacman -Si "$pkg" &>/dev/null; then
        log_success "[Official] $pkg"
        pacman -Si "$pkg"
        valid_pkgs+=("$pkg")
      elif gum_spin --spinner dot --title "Checking $pkg in AUR..." -- yay -Si "$pkg" &>/dev/null; then
        log_info "[AUR] $pkg"
        yay -Si "$pkg"
        valid_pkgs+=("$pkg")
      else
        log_error "Package '$pkg' not found in repos or AUR."
        not_found_pkgs+=("$pkg")
      fi
      echo ""
    done

    if ((${#valid_pkgs[@]} == 0)); then
      log_error "No valid packages to install."
      return 1
    fi

    if ! gum_confirm "Install ${#valid_pkgs[@]} package(s)?"; then
      log_warn "Aborted."
      return 1
    fi

    set -- "${valid_pkgs[@]}"
  fi

  for pkg in "$@"; do
    if pacman -Si "$pkg" &>/dev/null; then
      log_header "Install [Official] $pkg"

      if (($# == 1)); then
        pacman -Si "$pkg"
      fi

      if pacman -Qq "$pkg" &>/dev/null; then
        if ! gum_confirm "Reinstall '$pkg'?"; then
          log_warn "Skipped: $pkg"
          skipped_pkgs+=("$pkg")
          continue
        fi
      else
        if ! gum_confirm "Install '$pkg'?"; then
          log_warn "Skipped: $pkg"
          skipped_pkgs+=("$pkg")
          continue
        fi
      fi

      if sudo pacman -S --noconfirm "$pkg"; then
        installed_pkgs+=("$pkg")
      else
        log_error "Failed to install '$pkg'."
        log_info "Hint: check the error above — may be a conflict or missing dependency"
        error_pkgs+=("$pkg")
      fi
    elif yay -Si "$pkg" &>/dev/null; then
      log_header "Install [AUR] $pkg"

      if (($# == 1)); then
        yay -Si "$pkg"
      fi

      if yay -Qq "$pkg" &>/dev/null; then
        if ! gum_confirm "Reinstall '$pkg'?"; then
          log_warn "Skipped: $pkg"
          skipped_pkgs+=("$pkg")
          continue
        fi
      else
        if ! gum_confirm "Install '$pkg'?"; then
          log_warn "Skipped: $pkg"
          skipped_pkgs+=("$pkg")
          continue
        fi
      fi

      if yay -S --answerclean "None" --answerdiff "None" --noconfirm "$pkg"; then
        installed_pkgs+=("$pkg")
      else
        log_error "Failed to install '$pkg'."
        log_info "Hint: AUR builds can fail due to missing deps or PKGBUILD errors — check output above"
        error_pkgs+=("$pkg")
      fi
    else
      if (($# == 1)); then
        log_error "Package '$pkg' could not be found via pacman or yay."
      fi
      not_found_pkgs+=("$pkg")
    fi
  done

  if ((${#installed_pkgs[@]} > 0)); then
    log_header "Install Summary"
    print_summary installed_pkgs "Installed" "$GB_FG_AQUA"
    print_summary skipped_pkgs "Skipped" "$GB_FG_YELLOW"
    print_summary not_found_pkgs "Not found" "$GB_FG_RED"
    print_summary error_pkgs "Failed" "$GB_FG_RED"
  elif ((${#not_found_pkgs[@]} > 0 || ${#skipped_pkgs[@]} > 0 || ${#error_pkgs[@]} > 0)); then
    log_warn "Nothing installed."
    return 1
  fi
}

do_remove() {
  local not_installed_pkgs=()
  local removed_pkgs=()
  local skipped_pkgs=()
  local error_pkgs=()

  if (($# > 1)); then
    log_header "Checking packages..."

    local valid_pkgs=()
    for pkg in "$@"; do
      if pacman -Qq "$pkg" &>/dev/null; then
        log_success "[Official] $pkg"
        pacman -Si "$pkg" 2>/dev/null || pacman -Qi "$pkg"
        valid_pkgs+=("$pkg")
      elif yay -Qq "$pkg" &>/dev/null; then
        log_info "[AUR] $pkg"
        yay -Si "$pkg" 2>/dev/null || yay -Qi "$pkg"
        valid_pkgs+=("$pkg")
      else
        log_error "Package '$pkg' is not currently installed."
        not_installed_pkgs+=("$pkg")
      fi
      echo ""
    done

    if ((${#valid_pkgs[@]} == 0)); then
      log_error "No installed packages to remove."
      return 1
    fi

    if ! gum_confirm "Remove ${#valid_pkgs[@]} package(s)?"; then
      log_warn "Aborted."
      return 1
    fi

    set -- "${valid_pkgs[@]}"
  fi

  for pkg in "$@"; do
    if pacman -Qq "$pkg" &>/dev/null; then
      if (($# == 1)); then
        log_header "Remove: $pkg"
        pacman -Si "$pkg" 2>/dev/null || pacman -Qi "$pkg"
      fi

      if gum_confirm "Remove '$pkg'?"; then
        if sudo pacman -R --noconfirm "$pkg"; then
          removed_pkgs+=("$pkg")
        else
          log_error "Failed to remove '$pkg'."
          log_info "Hint: use 'sudo pacman -Rdd $pkg' to force remove (may break dependencies)"
          error_pkgs+=("$pkg")
        fi
      else
        log_warn "Skipped: $pkg"
        skipped_pkgs+=("$pkg")
      fi
    elif yay -Qq "$pkg" &>/dev/null; then
      if (($# == 1)); then
        log_header "Remove (AUR): $pkg"
        yay -Si "$pkg" 2>/dev/null || yay -Qi "$pkg"
      fi

      if gum_confirm "Remove '$pkg'?"; then
        if yay -R --noconfirm "$pkg"; then
          removed_pkgs+=("$pkg")
        else
          log_error "Failed to remove '$pkg'."
          log_info "  Hint: use 'yay -Rdd $pkg' to force remove (may break dependencies)"
          error_pkgs+=("$pkg")
        fi
      else
        log_warn "Skipped: $pkg"
        skipped_pkgs+=("$pkg")
      fi
    else
      if (($# == 1)); then
        log_error "Package '$pkg' is not currently installed."
      fi
      not_installed_pkgs+=("$pkg")
    fi
  done

  if ((${#removed_pkgs[@]} > 0)); then
    log_header "Remove Summary"
    print_summary removed_pkgs "Removed" "$GB_FG_AQUA"
    print_summary skipped_pkgs "Skipped" "$GB_FG_YELLOW"
    print_summary not_installed_pkgs "Not installed" "$GB_FG_RED"
    print_summary error_pkgs "Failed" "$GB_FG_RED"
  elif ((${#not_installed_pkgs[@]} > 0 || ${#skipped_pkgs[@]} > 0 || ${#error_pkgs[@]} > 0)); then
    log_warn "Nothing removed."
    return 1
  fi
}

do_pkgbuild() {
  local viewed_pkgs=()
  local not_found_pkgs=()
  local failed_pkgs=()

  for pkg in "$@"; do
    if pacman -Si "$pkg" &>/dev/null || yay -Si "$pkg" &>/dev/null; then
      local tmp_file
      tmp_file=$(mktemp -t pkgbuild-XXXXXX.sh)
      trap 'rm -f "$tmp_file"' EXIT

      if gum_spin --spinner line --title "Fetching PKGBUILD for $pkg..." -- sh -c "yay -Gp '$pkg' > '$tmp_file'"; then
        if [[ -s $tmp_file ]]; then
          $EDITOR "$tmp_file"
          viewed_pkgs+=("$pkg")
        else
          log_error "Could not retrieve a valid PKGBUILD for '$pkg'."
          failed_pkgs+=("$pkg")
        fi
      else
        log_error "Fetch transaction failed for '$pkg'."
        failed_pkgs+=("$pkg")
      fi

      rm -f "$tmp_file"
      trap - EXIT
    else
      log_error "Package '$pkg' could not be found."
      not_found_pkgs+=("$pkg")
    fi
  done

  if ((${#viewed_pkgs[@]} > 0)); then
    log_header "PKGBUILD Summary"
    print_summary viewed_pkgs "Viewed" "$GB_FG_AQUA"
    print_summary not_found_pkgs "Not found" "$GB_FG_RED"
    print_summary failed_pkgs "Failed" "$GB_FG_RED"
  elif ((${#not_found_pkgs[@]} > 0 || ${#failed_pkgs[@]} > 0)); then
    log_warn "Nothing viewed."
    return 1
  fi
}

do_clean() {
  if ! gum_confirm "Clean ALL package cache?"; then
    log_warn "Aborted."
    return 1
  fi

  log_header "Cleaning cache..."
  yes | yay -Scc
  yes | sudo pacman -Scc
  sudo rm -rf /var/cache/pacman/pkg/download-*

  log_success "Cache cleaned."
}

# =============================================================================
# INTERACTIVE MODE
# =============================================================================

interactive_submenu() {
  local action=$1
  local sc

  case $action in
  install) sc="install" ;;
  remove) sc="remove" ;;
  pkgbuild) sc="pkgbuild" ;;
  esac

  while true; do
    clear
    log_header "Arch Package Manager › $action"

    local raw_pkgs
    raw_pkgs=$(gum input \
      --header "Package names (space-separated):" \
      --placeholder "e.g. neovim git curl — Esc to go back" \
      --width 80 \
      --header.foreground "$GB_FG_BLUE" \
      --prompt.foreground "$GB_FG_YELLOW" \
      --cursor.foreground "$GB_FG_YELLOW") || return

    raw_pkgs=${raw_pkgs//,/ }
    [[ -z $raw_pkgs ]] && continue

    local packages=()
    set -f
    packages=($raw_pkgs)
    set +f

    case $sc in
    install) do_install "${packages[@]}" ;;
    remove) do_remove "${packages[@]}" ;;
    pkgbuild) do_pkgbuild "${packages[@]}" ;;
    esac

    if ! gum_confirm --affirmative "Try Again" --negative "Back to menu" ""; then
      return
    fi
  done
}

interactive_mode() {
  while true; do
    clear
    log_header "Arch Package Manager"

    local subcmd
    subcmd=$(gum choose \
      --header "Choose an action:" \
      --cursor "→ " \
      --cursor.foreground "$GB_FG_YELLOW" \
      --selected.foreground "$GB_FG_AQUA" \
      --header.foreground "$GB_FG_BLUE" \
      "Install Packages" \
      "Remove Packages" \
      "View PKGBUILD" \
      "Clean Cache" \
      "Exit")

    [[ -z $subcmd || $subcmd == "Exit" ]] && log_warn "Bye! :p" && exit 0

    case $subcmd in
    "Install Packages") interactive_submenu "install" ;;
    "Remove Packages") interactive_submenu "remove" ;;
    "View PKGBUILD") interactive_submenu "pkgbuild" ;;
    "Clean Cache") do_clean ;;
    esac
  done
}

# =============================================================================
# INITIAL VALIDATION
# =============================================================================

if (($# == 0)); then
  interactive_mode
  exit 0
elif (($# == 1)); then
  print_usage
  exit 1
fi

subcommand=$1
shift

cleaned=()
for pkg in "$@"; do
  cleaned+=("${pkg//,/}")
done
set -- "${cleaned[@]}"

# =============================================================================
# SUBCOMMAND EXECUTION
# =============================================================================

case $subcommand in
install | i) do_install "$@" ;;
remove | r) do_remove "$@" ;;
pkgbuild | b) do_pkgbuild "$@" ;;
clean | c) do_clean ;;
*)
  log_error "Unknown subcommand '$subcommand'"
  print_usage
  exit 1
  ;;
esac
