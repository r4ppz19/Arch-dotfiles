#!/bin/bash
SERVICE="$1"

while true; do
  docker compose logs -f --no-log-prefix "$SERVICE"
  sleep 2
done
