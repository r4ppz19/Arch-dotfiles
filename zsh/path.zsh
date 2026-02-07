typeset -U path
path=(
  $PNPM_HOME
  $BUN_INSTALL/bin
  $HOME/.local/bin
  $GOPATH/bin
  $HOME/.cargo/bin
  $HOME/Arch-dotfiles/scripts
  $HOME/.local/share/gem/ruby/3.4.0/bin/
  $HOME/.npm-global/bin
  $path[@]
)
export PATH
