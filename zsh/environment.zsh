# environment variables
export PNPM_HOME="/home/r4ppz/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
export BUN_INSTALL_CACHE_DIR="$BUN_INSTALL/install/cache"
export GOPATH="$HOME/.go"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export MANPAGER="nvim +Man!"

export EDITOR='nvim'
export VISUAL='nvim'
export SYSTEMD_EDITOR='nvim'

export KEYTIMEOUT=1
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# ZSH Autosuggestions optimizations
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# FZF-tab optimizations
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export PREVIEW_CMD="bat --style=numbers --color=always {} || cat {}"
export FZF_CTRL_T_OPTS="--preview \"$PREVIEW_CMD\" --height 50%"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --margin=0 --padding=0"
export FZF_CTRL_R_OPTS="--preview \"$PREVIEW_CMD\" --preview-window down:3:hidden:wrap"
