# History Setup
setopt APPEND_HISTORY       # Append history logs instead of overwriting the target file
setopt EXTENDED_HISTORY     # Add precise Unix timestamps per logged entry
setopt HIST_VERIFY          # Load recalled commands into the active prompt buffer for editing before execution
setopt HIST_IGNORE_SPACE    # Completely ignore commands starting with a literal space character
setopt HIST_IGNORE_DUPS     # Do not write a command to the history file if it duplicates the previous one
setopt HIST_IGNORE_ALL_DUPS # If a new command duplicates an older one, remove the older one from the history list

# Shell Operations
setopt INTERACTIVE_COMMENTS # Allow `#` to act as an execution comment interactively
setopt EXTENDED_GLOB        # Enable powerful pattern matching features (`^`, `~`, `**/`)
setopt NOTIFY               # Immediately broadcast status updates for background processes
