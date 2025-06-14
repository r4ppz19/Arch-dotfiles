# This file sources other configuration files to keep things modular.
# symlinked to ~/.zshrc.
# The order of sourcing is critical!

# Basic shell setup - check if interactive
# =========================================================================
# Only load interactive-specific configurations in interactive shells.
# This prevents issues when running non-interactive scripts that start with zsh.
if [[ $- == *i* ]]; then

  # Instant Prompt (Powerlevel10k) - Load extremely early for perceived speed
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

  # Source Modular Configuration Files
  # =========================================================================
  # Define the base directory for your modular Zsh configuration files.
  local zsh_config_dir="$HOME/Arch-dotfiles/zsh/"

  # Source the modular files in a logical sequence from the determined directory.
  if [[ -d "$zsh_config_dir" ]]; then
    # Order explained below, but roughly: Environment -> Behavior -> Commands -> Interactive
    source "$zsh_config_dir/path.zsh"         || echo "Error sourcing $zsh_config_dir/path.zsh"
    source "$zsh_config_dir/env_vars.zsh"     || echo "Error sourcing $zsh_config_dir/env_vars.zsh"
    source "$zsh_config_dir/setopt.zsh"       || echo "Error sourcing $zsh_config_dir/setopt.zsh"
    # Aliases and functions define commands. Source them after environment is ready.
    source "$zsh_config_dir/aliases.zsh"      || echo "Error sourcing $zsh_config_dir/aliases.zsh"
    source "$zsh_config_dir/functions.zsh"    || echo "Error sourcing $zsh_config_dir/functions.zsh"
    # Keybindings define interactive behavior, often relying on functions/aliases. Source last.
    source "$zsh_config_dir/keybindings.zsh"  || echo "Error sourcing $zsh_config_dir/keybindings.zsh"
  else
    echo "Warning: Modular Zsh config directory '$zsh_config_dir' not found. Skipping modular config."
    echo "Please ensure your Zsh dotfiles are in '$dotfiles_zsh_dir'."
  fi

  # Load Powerlevel10k config - Typically loaded last
  # =========================================================================
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fi # End of interactive shell check

# Any configuration that *must* run in non-interactive shells (e.g., basic PATH
# adjustments for scripts) would go here, outside the 'if' block.

# =========================================================================
