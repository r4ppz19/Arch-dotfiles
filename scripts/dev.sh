#!/bin/bash
set -euo pipefail

SESSION="${1:-dev}"

FRONTDIR='/home/r4ppz/Project/research-repository-frontend/'
BACKDIR='/home/r4ppz/Project/research-repository-backend/'
DOCSDIR='/home/r4ppz/Project/research-repo-docs/'

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "FULLS"
  tmux new-window -t "$session:" -n "DOCS"
  tmux new-window -t "$session:" -n "DOCKER"

  tmux send-keys -t "$session:FULLS" "nvim -c 'tcd ${FRONTDIR}' -c 'edit ${FRONTDIR}/README.md' -c 'tabnew' -c 'tcd ${BACKDIR}' -c 'edit ${BACKDIR}/README.md'" C-m

  tmux send-keys -t "$session:DOCS" "cd ${DOCSDIR}; v" C-m
  tmux send-keys -t "$session:DOCKER" "cd ${BACKDIR}; lazydocker" C-m

  tmux select-window -t "$session:0"
}

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
