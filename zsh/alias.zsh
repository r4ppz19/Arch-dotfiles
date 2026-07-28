# Built-in improvements
alias ls='eza --icons --group-directories-first --color=auto'
alias la='eza -a --icons --group-directories-first --color=auto'
alias ll='eza -lh --icons --group-directories-first --color=auto'
alias less='less -SRXF'
alias mv='mv -v'
alias cp='cp -v'
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias open='xdg-open'
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias net='nmtui'

alias v='nvim'
alias nv='nvim'
alias lg='lazygit'
alias ld='lazydocker'
alias top='btop'
alias news='clx -n --indent 3 --article-width 100 --comment-width 100 --reader-mode-images --pages 5'
alias rss='bulletty'
alias restore="gtrash r"
alias bm="bashmount"
alias op='opencode'
alias md='glow'
alias pac='pacseek'
alias copy='wl-copy'
alias blue='bluetuith'
alias music='cliamp'

# require sudo
alias slg='sudo LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml" GIT_CONFIG_GLOBAL="$HOME/.gitconfig" EDITOR="nvim -R -n" lazygit'

# script
alias t="$DOTFILES/scripts/tmux-init.sh"
alias of="$DOTFILES/scripts/open-file.sh"
alias sm="$DOTFILES/scripts/tmux-session-manager.py"
alias dev="$DOTFILES/scripts/dev.sh"
alias vo="$DOTFILES/scripts/vault.sh open"
alias vc="$DOTFILES/scripts/vault.sh close"
alias ytdl="$DOTFILES/scripts/yt-audio-dl.sh"
alias apm="$DOTFILES/scripts/arch-package-manager.sh"
