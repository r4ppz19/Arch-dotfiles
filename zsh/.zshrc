# symlinked to ~/.zshrc.

if [[ $- == *i* ]]; then
  # Instant Prompt (Powerlevel10k)
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  # Plugin Management (Antidote)
  autoload -Uz compinit
  compinit

  zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
  [[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt
  fpath=($HOME/.antidote/functions $fpath)
  autoload -Uz antidote
  if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
  fi
  source ${zsh_plugins}.zsh

  # Source Configuration Files
  local zsh_config_dir="$DOTFILES/zsh/"

  if [[ -d "$zsh_config_dir" ]]; then
    source "$zsh_config_dir/path.zsh"
    source "$zsh_config_dir/setopt.zsh"
    source "$zsh_config_dir/environment.zsh"
    source "$zsh_config_dir/alias.zsh"
    source "$zsh_config_dir/keybinding.zsh"
    source "$zsh_config_dir/function.zsh"
    source "$zsh_config_dir/tmux_rename.zsh"
    source "$zsh_config_dir/.p10k.zsh"
  else
    echo "Warning: zsh config directory '$zsh_config_dir' not found."
  fi

  # Auto-attach tmux for the first intance of kitty
  if [[ "$TERM" == "xterm-kitty" && -z "$TMUX" && -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    if [[ $(hyprctl clients | grep -c "class: kitty") -eq 1 ]]; then
      if [[ -d "$DOTFILES/scripts" ]]; then
        $DOTFILES/scripts/tmux-init.sh
      fi
    fi
  fi
fi
