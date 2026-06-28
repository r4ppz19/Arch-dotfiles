#!/bin/bash

if ! command -v gum &>/dev/null; then
  echo "Error: 'gum' is required but not installed. Please install it first." >&2
  exit 1
fi

: "${EDITOR:=vi}"

# Gruvbox color palette
GB_DARK0="#282828"
GB_FG_WHITE="#ebdbb2"
GB_FG_YELLOW="#fabd2f"
GB_FG_BLUE="#83a598"
GB_FG_RED="#fb4934"
GB_FG_AQUA="#8ec07c"

log_header() {
  gum style --border normal --border-foreground "$GB_FG_BLUE" --padding "0 2" --margin "0 0 1 0" --bold -- "$1"
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
  gum style --foreground "$GB_FG_BLUE" -- "Usage: $0 <install|remove|pkgbuild|upgrade|clean> <package...>"
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

  gum style --foreground "$color" -- "$label (${#arr[@]}):"
  for item in "${arr[@]}"; do
    gum style --foreground "$color" -- "  - $item"
  done
}

open_editor() {
  local file=$1
  if [[ $EDITOR == *code* || $EDITOR == *codium* ]]; then
    $EDITOR --wait "$file"
  else
    $EDITOR "$file"
  fi
}

_pkg_installed() {
  pacman -Qq "$1" &>/dev/null
}

_pkg_exists() {
  pacman -Si "$1" &>/dev/null || yay -Si "$1" &>/dev/null
}

view_pkgbuild() {
  local pkg=$1
  local tmp_file
  tmp_file=$(mktemp -t pkgbuild-XXXXXX.sh)

  if gum_spin --spinner line --title "Fetching PKGBUILD for $pkg..." -- sh -c "yay -Gp '$pkg' > '$tmp_file'"; then
    if [[ -s $tmp_file ]]; then
      open_editor "$tmp_file"
    else
      log_error "Could not retrieve a valid PKGBUILD for '$pkg'."
    fi
  else
    log_error "Fetch transaction failed for '$pkg'."
  fi

  rm -f "$tmp_file"
}

# =============================================================================
# ACTION FUNCTIONS
# =============================================================================

do_install() {
  local not_found_pkgs=()
  local installed_pkgs=()
  local reinstalled_pkgs=()
  local skipped_pkgs=()
  local error_pkgs=()

  for pkg in "$@"; do
    local source

    if ! _pkg_exists "$pkg"; then
      log_error "Package '$pkg' not found in repos or AUR."
      not_found_pkgs+=("$pkg")
      echo ""
      continue
    fi

    if pacman -Si "$pkg" &>/dev/null; then
      log_header "Package information for $pkg"
      pacman -Si "$pkg"
      source="official"
    else
      log_header "Package information for $pkg"
      yay -Si "$pkg"
      source="aur"
    fi
    echo ""

    local reinstall=false
    _pkg_installed "$pkg" && reinstall=true

    local prompt="Install '$pkg'?"
    $reinstall && prompt="Reinstall '$pkg'?"

    if ! gum_confirm "$prompt"; then
      log_warn "Skipped: $pkg"
      skipped_pkgs+=("$pkg")
      continue
    fi

    if $reinstall; then
      log_header "Reinstalling: $pkg"
    else
      log_header "Installing: $pkg"
    fi

    local ok=false

    if [[ $source == "official" ]]; then
      if sudo pacman -S --noconfirm "$pkg"; then
        ok=true
      else
        log_error "Failed to install '$pkg'."
        log_info "Hint: check the error above — may be a conflict or missing dependency"
        error_pkgs+=("$pkg")
      fi
    else
      local view_opts=()
      local view_prompt="View PKGBUILD before installing '$pkg'?"
      $reinstall && view_opts+=(--default=false) && view_prompt="View PKGBUILD before reinstalling '$pkg'?"
      gum_confirm "${view_opts[@]}" "$view_prompt" && view_pkgbuild "$pkg"

      if yay -S --answerclean "None" --answerdiff "None" --noconfirm "$pkg"; then
        ok=true
      else
        log_error "Failed to install '$pkg'."
        log_info "Hint: AUR builds can fail due to missing deps or PKGBUILD errors — check output above"
        error_pkgs+=("$pkg")
      fi
    fi

    if $ok; then
      if $reinstall; then
        reinstalled_pkgs+=("$pkg")
      else
        installed_pkgs+=("$pkg")
      fi
    fi
    echo ""
  done

  if ((${#installed_pkgs[@]} > 0 || ${#reinstalled_pkgs[@]} > 0)); then
    log_header "Install Summary"
    print_summary installed_pkgs "Installed" "$GB_FG_AQUA"
    print_summary reinstalled_pkgs "Reinstalled" "$GB_FG_AQUA"
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

  for pkg in "$@"; do
    local real_pkg source

    real_pkg=$(pacman -Qq "$pkg" 2>/dev/null) || {
      log_error "Package '$pkg' is not currently installed."
      not_installed_pkgs+=("$pkg")
      echo ""
      continue
    }

    if pacman -Qn "$real_pkg" &>/dev/null; then
      log_header "Package information for $pkg"
      pacman -Si "$real_pkg" 2>/dev/null || pacman -Qi "$real_pkg"
      source="native"
    else
      log_header "Package information for $pkg"
      yay -Si "$real_pkg" 2>/dev/null || yay -Qi "$real_pkg"
      source="foreign"
    fi
    echo ""

    if ! gum_confirm "Remove '$real_pkg'?"; then
      log_warn "Skipped: $pkg"
      skipped_pkgs+=("$pkg")
      continue
    fi

    log_header "Removing: $real_pkg"

    if [[ $source == "native" ]]; then
      if sudo pacman -R --noconfirm "$real_pkg"; then
        removed_pkgs+=("$pkg")
      else
        log_error "Failed to remove '$real_pkg'."
        log_info "Hint: use 'sudo pacman -Rdd $real_pkg' to force remove (may break dependencies)"
        error_pkgs+=("$pkg")
      fi
    else
      if yay -R --noconfirm "$real_pkg"; then
        removed_pkgs+=("$pkg")
      else
        log_error "Failed to remove '$real_pkg'."
        log_info "Hint: use 'yay -Rdd $real_pkg' to force remove (may break dependencies)"
        error_pkgs+=("$pkg")
      fi
    fi
    echo ""
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
    if _pkg_exists "$pkg"; then
      local tmp_file
      tmp_file=$(mktemp -t pkgbuild-XXXXXX.sh)

      if gum_spin --spinner line --title "Fetching PKGBUILD for $pkg..." -- sh -c "yay -Gp '$pkg' > '$tmp_file'"; then
        if [[ -s $tmp_file ]]; then
          open_editor "$tmp_file"
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

do_upgrade() {
  log_header "Upgrading system..."
  echo ""
  if yay -Syu --editmenu --diffmenu; then
    echo ""
    log_success "System upgraded."
  else
    echo ""
    log_warn "Upgrade aborted or failed."
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

  log_success "Cache cleaned."
}

# =============================================================================
# INTERACTIVE MODE
# =============================================================================

interactive_submenu() {
  local action=$1

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

    case $action in
    install) do_install "${packages[@]}" ;;
    remove) do_remove "${packages[@]}" ;;
    pkgbuild) do_pkgbuild "${packages[@]}" ;;
    esac

    echo ""
    read -n1 -p "Press any key to continue..."
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
      "Upgrade System" \
      "View PKGBUILD" \
      "Clean Cache" \
      "Exit")

    [[ -z $subcmd || $subcmd == "Exit" ]] && log_warn "Bye! :p" && exit 0

    case $subcmd in
    "Install Packages") interactive_submenu "install" ;;
    "Remove Packages") interactive_submenu "remove" ;;
    "View PKGBUILD") interactive_submenu "pkgbuild" ;;
    "Upgrade System")
      do_upgrade
      echo ""
      read -n1 -p "Press any key to continue..."
      ;;
    "Clean Cache")
      do_clean
      echo ""
      read -n1 -p "Press any key to continue..."
      ;;
    esac
  done
}

# =============================================================================
# INITIAL VALIDATION
# =============================================================================

if (($# == 0)); then
  interactive_mode
  exit 0
fi

subcommand=$1
shift

case $subcommand in
upgrade | u | clean | c) ;;
*)
  if (($# == 0)); then
    print_usage
    exit 1
  fi
  ;;
esac

cleaned=()
for pkg in "$@"; do
  IFS=',' read -ra parts <<<"$pkg"
  cleaned+=("${parts[@]}")
done
set -- "${cleaned[@]}"

# =============================================================================
# SUBCOMMAND EXECUTION
# =============================================================================

case $subcommand in
install | i) do_install "$@" ;;
remove | r) do_remove "$@" ;;
pkgbuild | b) do_pkgbuild "$@" ;;
upgrade | u) do_upgrade ;;
clean | c) do_clean ;;
*)
  log_error "Unknown subcommand '$subcommand'"
  print_usage
  exit 1
  ;;
esac
