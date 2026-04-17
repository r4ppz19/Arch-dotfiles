# Tmux auto-rename

typeset -gA PROC_MAP=(
  q LLM
  f FILE
  nv EDIT
  op LLM
  top TASK
  ollama LLM
  news NEWS
  pac PAC
  pgcli DB
  lnav LOGS
  bluetuith BLUET
  net NET
  lg GIT
  ld DOCKER
  yay YAY
  npm NPM
  late LATE
  ssh SSH
  tetro-tui TETRIS
  kew MUSIC
)

typeset -gA DIR_MAP=(
  "/" ROOT
  "/etc" ETC
  "/mnt/SHARED" SHARED
  "/run/media" MOUNT
  "/tmp" TEMP

  "$HOME" HOME
  "$HOME/Arch-dotfiles" DOTS
  "$HOME/Arch-dotfiles/nvim" VDOTS
  "$HOME/.config" DOTS
  "$HOME/.local" LOCAL
  "$HOME/Books" BOOKS
  "$HOME/School" SCHOOL
  "$HOME/Music" MUSIC
  "$HOME/Documents" DOCUMENTS
  "$HOME/Downloads" DOWNLOADS
  "$HOME/Games" GAMES
  "$HOME/Pictures" PICS
  "$HOME/Repositories" REPOS
  "$HOME/Vault" VAULT
  "$HOME/Videos" VIDS

  "$HOME/Projects" PROJECTS
  "$HOME/Projects/r4ppz.github.io" PWEB
  "$HOME/Projects/research-repository" RESEARCH
  "$HOME/Projects/research-repository/docs" DOCS
  "$HOME/Projects/research-repository/backend" BACK
  "$HOME/Projects/research-repository/frontend" FRONT
)

_tmux_is_renamable() {
  [[ -z "$TMUX" || -n "$NVIM" ]] && return 1

  # Single call to get pane count and the user-defined lock option
  local tmux_state
  tmux_state=$(tmux display-message -p '#{window_panes}|#{@tmux_rename_locked}' 2>/dev/null)

  # If locked is "1" or "on", or panes > 1, we don't rename
  [[ "$tmux_state" == *"|1"* || "$tmux_state" == *"|on"* ]] && return 1
  [[ "${tmux_state%%|*}" -gt 1 ]] && return 1

  return 0
}

_tmux_rename_preexec() {
  _tmux_is_renamable || return 0

  # Safer parsing of the command string
  local -a cmd_args
  cmd_args=(${(z)1})
  local cmd="${cmd_args[1]##*/}"

  [[ -z "$cmd" || "$cmd" == (zsh|bash|sh) ]] && return 0

  local name="${PROC_MAP[$cmd]}"
  [[ -n "$name" ]] && tmux rename-window -t "$TMUX_PANE" "$name" 2>/dev/null
}

_tmux_rename_precmd() {
  _tmux_is_renamable || return 0

  # Clean PWD: strip trailing slash, but handle root explicitly
  local clean_pwd="${PWD%/}"
  [[ -z "$clean_pwd" ]] && clean_pwd="/"

  local dir_name="${DIR_MAP[$clean_pwd]:-CMD}"

  tmux rename-window -t "$TMUX_PANE" "$dir_name" 2>/dev/null
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tmux_rename_preexec
add-zsh-hook precmd _tmux_rename_precmd
