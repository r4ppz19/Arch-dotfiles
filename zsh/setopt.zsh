# History Setup
setopt append_history    # Append history logs instead of overwriting the target file
setopt extended_history  # Add precise Unix timestamps per logged entry
setopt hist_ignore_space # Completely ignore commands starting with a literal space character
setopt hist_verify       # Load recalled commands into the active prompt buffer for editing before execution

# Shell Operations
setopt interactive_comments # Allow `#` to act as an execution comment interactively
setopt extended_glob        # Enable powerful pattern matching features (`^`, `~`, `**/`)
setopt notify               # Immediately broadcast status updates for background processes
