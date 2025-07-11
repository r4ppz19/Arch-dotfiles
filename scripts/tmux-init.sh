#!/bin/bash

SESSION="${1:-main}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n "R4PPZ"
tmux new-window -t "$SESSION:1" -n "CMD"
tmux new-window -t "$SESSION:2" -n "TASK"

tmux send-keys -t "$SESSION:CMD" 'y' C-m
tmux send-keys -t "$SESSION:TASK" 'btop' C-m

tmux select-window -t "$SESSION:0"
tmux attach -t "$SESSION"
