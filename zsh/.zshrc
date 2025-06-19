# symlinked to ~/.zshrc.

# Basic shell setup - check if interactive
# =========================================================================
if [[ $- == *i* ]]; then

  # Instant Prompt (Powerlevel10k)
  # =========================================================================
  # Load Powerlevel10k instant prompt cache. Keep this near the top!
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  # Plugin Management (Antidote) and Completions
  # =========================================================================
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
  # =========================================================================
  local zsh_config_dir="$HOME/Arch-dotfiles/zsh/"

  if [[ -d "$zsh_config_dir" ]]; then
    # Environment -> Behavior -> Commands -> Interactive
    source "$zsh_config_dir/path.zsh"         || echo "Error sourcing $zsh_config_dir/path.zsh"
    source "$zsh_config_dir/env_vars.zsh"     || echo "Error sourcing $zsh_config_dir/env_vars.zsh"
    source "$zsh_config_dir/setopt.zsh"       || echo "Error sourcing $zsh_config_dir/setopt.zsh"
    source "$zsh_config_dir/aliases.zsh"      || echo "Error sourcing $zsh_config_dir/aliases.zsh"
    source "$zsh_config_dir/functions.zsh"    || echo "Error sourcing $zsh_config_dir/functions.zsh"
    source "$zsh_config_dir/keybindings.zsh"  || echo "Error sourcing $zsh_config_dir/keybindings.zsh"
  else
    echo "Warning: Zsh config directory '$zsh_config_dir' not found."
    echo "Please ensure your Zsh dotfiles are in '$dotfiles_zsh_dir'."
  fi

  # Load Powerlevel10k config - Typically loaded last
  # =========================================================================
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fi

# Any configuration that *must* run in non-interactive shells (e.g., basic PATH
# adjustments for scripts) would go here, outside the 'if' block.

# =========================================================================
