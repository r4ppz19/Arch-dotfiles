#  ╭─────────────────────────────────────────────╮
#  │              Path Management                │
#  ╰─────────────────────────────────────────────╯

typeset -U path
path=(
  $HOME/.local/bin
  $GOPATH/bin
  $HOME/.cargo/bin
  $HOME/Arch-dotfiles/scripts
  $HOME/.local/share/gem/ruby/3.4.0/bin/
  ${path[@]}
)
export PATH
