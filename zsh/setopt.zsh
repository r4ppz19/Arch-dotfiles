#  ╭─────────────────────────────────────────────╮
#  │               Usefull Setopt                │
#  ╰─────────────────────────────────────────────╯

setopt append_history         # Append history instead of overwriting
setopt inc_append_history     # Write history immediately, not just on exit
setopt share_history          # Share history across all sessions
setopt hist_ignore_all_dups   # Prevent any duplicate commands from being stored
setopt hist_reduce_blanks     # Strip extra whitespace
setopt hist_verify            # Allow you to edit history-recalled command before running
setopt extended_history       # Add timestamps to history
setopt hist_expire_dups_first # Prioritize deleting duplicates when trimming
setopt hist_find_no_dups      # Prevent duplicates from showing in reverse-i-search (Ctrl+R)
setopt hist_save_no_dups      # Don't write duplicates to `.zsh_history`
setopt interactive_comments   # Allow `#` to be used as comments even interactively
setopt hist_ignore_space      # Don't save commands starting with a space
setopt extended_glob          # Enables powerful globbing (like `^`, `~`, `**/`, etc.)
setopt notify                 # Immediately notify background job status
