#!/bin/bash
set -euo pipefail

SESSION="${1:-dev2}"
COMPOSE_FILE="/home/r4ppz/Project/research-repository-backend/docker-compose.yml"
PROJECTDIR='/home/r4ppz/Project/'
BACKDIR='/home/r4ppz/Project/research-repository-backend/'
DOCSDIR='/home/r4ppz/Project/research-repo-docs/'

wait_for_db() {
  echo "Waiting for Postgres to accept queries..."
  until docker exec db pg_isready -U "${POSTGRES_USER:-testing}" >/dev/null 2>&1; do
    sleep 1
  done
  echo "Postgres is fully ready."
}

wait_for_backend() {
  echo "Waiting for backend service to be healthy..."
  until docker compose -f "$COMPOSE_FILE" ps backend | grep -q "Up"; do
    sleep 1
  done
  echo "Backend service is running."
}

start_compose() {
  if ! docker compose -f "$COMPOSE_FILE" ps | grep -q "Up"; then
    echo "Compose stack not running. Starting..."
    docker compose -f "$COMPOSE_FILE" up -d
  fi
}

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "DOCS"
  tmux new-window -t "$session:" -n "DB"
  tmux new-window -t "$session:" -n "LOGS"

  tmux send-keys -t "$session:DOCS" "cd ${DOCSDIR}; v" C-m

  wait_for_db
  tmux send-keys -t "$session:DB" "cd ${PROJECTDIR}; pgcli -h localhost -p 5432 -U testing research-repo-db" C-m

  wait_for_backend
  tmux send-keys -t "$session:LOGS" "cd ${BACKDIR}; docker logs -f backend | lnav" C-m
}

# start_compose

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
