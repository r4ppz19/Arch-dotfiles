#  ╭─────────────────────────────────────────────╮
#  │              Path Management                │
#  ╰─────────────────────────────────────────────╯

typeset -U path
path=(
  $HOME/.local/bin
  $GOPATH/bin
  $HOME/.cargo/bin
  $HOME/Arch-dotfiles/scripts
  ${path[@]}
)
export PATH
