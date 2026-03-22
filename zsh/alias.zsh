# Built-in improvements
alias ls='eza --icons --group-directories-first --color=auto'
alias la='eza -a --icons --group-directories-first --color=auto'
alias ll='eza -lh --icons --group-directories-first --color=auto'
alias tree='eza -T --icons --group-directories-first --color=auto'
alias less='less -SRXF'
alias mv='mv -v'
alias cp='cp -v'
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias open='xdg-open'
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

alias v='nvim'
alias lg='lazygit'
alias ld='lazydocker'
alias top='btop'
alias news='clx -n'
alias restore="gtrash r"
alias q="qwen -p"
alias bm="bashmount"
alias rcopy='rsync -avh --info=progress2 --partial --inplace'
alias rmirror='rsync -avh --delete --info=progress2 --partial --inplace'
alias op='opencode'
alias md='mdcat'

# services
alias smbon='sudo systemctl start smb.service nmb.service'
alias smboff='sudo systemctl stop smb.service nmb.service'
alias dockeron='sudo systemctl start docker.service docker.socket && echo "Docker started"'
alias dockeroff='sudo systemctl stop docker.service docker.socket && echo "Docker stopped"'

# script
alias of='~/Arch-dotfiles/scripts/open-file.sh'
alias ti='~/Arch-dotfiles/scripts/tmux-init.sh'
alias sm='~/Arch-dotfiles/scripts/tmux-session-manager.py'
# alias sm='. ~/Arch-dotfiles/zsh/session-manager.zsh'
alias dev='~/Arch-dotfiles/scripts/dev.sh'
alias dev2='~/Arch-dotfiles/scripts/dev2.sh'
alias vo='~/Arch-dotfiles/scripts/vault.sh open'
alias vc='~/Arch-dotfiles/scripts/vault.sh close'
