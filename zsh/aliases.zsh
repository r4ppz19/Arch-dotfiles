# =========================================================================================
# Aliases
# =========================================================================================
# Dependencies: eza, tree, bat, less, ranger, , trash
# gh (github cli + copilot extension), ollama (model: gemma3), tgpt
#
# improvements
alias ls="eza --icons --group-directories-first --color=auto"           # Default listing with icons
alias la="eza -a --icons --group-directories-first --color=auto"        # Show all files including hidden
alias ll="eza -lh --icons --group-directories-first --color=auto"       # Long format with human-readable sizes
alias tree="eza -T --icons --group-directories-first --color=auto"      # Tree view
alias less="less -SRX"
alias compress='tar -czvf'
alias mv="mv -iv"
alias cp="cp -iv"
alias mkdir="mkdir -pv"

# mine
alias r='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=$(cat "$HOME/.rangerdir"); cd "$LASTDIR"'
alias n='nnn'
alias v="nvim"
alias lg='lazygit'
alias sm='. ~/Arch-dotfiles/zsh/session-manager.zsh'
alias sm='python ~/Arch-dotfiles/scripts/tmux_session_managerV2.py'
alias ssh='TERM=xterm-256color ssh'

# AI
alias explain='gh copilot explain'
alias suggest='gh copilot suggest'
alias gemma3="tgpt --provider ollama --model gemma3"
alias poll="tgpt --provider pollinations"
