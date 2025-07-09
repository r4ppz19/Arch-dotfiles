#  ╭─────────────────────────────────────────────╮
#  │                  Aliases                    │
#  ╰─────────────────────────────────────────────╯

# Dependencies: eza, bat, less, ranger, btop, lazygit, tar,
# myscript , gh (github cli + copilot extension), ollama (model: gemma3),
# tgpt, neovim, ssh

# Built-in improvements
alias ls="eza --icons --group-directories-first --color=auto"
alias la="eza -a --icons --group-directories-first --color=auto"
alias ll="eza -lh --icons --group-directories-first --color=auto"
alias tree="eza -T --icons --group-directories-first --color=auto"
alias less="less -SRX"
alias mv="mv -v"
alias cp="cp -v"
alias mkdir="mkdir -pv"
alias ..="cd .."

alias compress='tar -czvf'
alias r='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=$(cat "$HOME/.rangerdir"); cd "$LASTDIR"'
alias v="nvim"
alias lg='lazygit'
# alias sm='. ~/Arch-dotfiles/zsh/session-manager.zsh'
alias sm='~/Arch-dotfiles/scripts/tmux-session-manager.py'
alias ssh='TERM=xterm-256color ssh'
alias top='btop'
alias of="~/Arch-dotfiles/scripts/open-file.sh"
alias fs="sudo systemctl start smb.service nmb.service"
alias fss="sudo systemctl stop smb.service nmb.service"

# AI
alias explain='gh copilot explain'
alias suggest='gh copilot suggest'
alias gemma3="tgpt --provider ollama --model gemma3"
alias poll="tgpt --provider pollinations"
