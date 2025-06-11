# =========================================================================================
# Path Management
# =========================================================================================

typeset -U path  # Ensure unique entries in PATH
path=(
  $HOME/.local/bin
  $GOPATH/bin/
  $HOME/.cargo/bin
  $HOME/Arch-dotfiles/scripts
  ${path[@]}
)
export PATH
