#!/usr/bin/env bash
SERVICE="$1"

# Continuously streams logs for a
# specified Docker Compose service.
#
# Used in LazyDocker custom cmd:
# lazydocker/config.yml

while true; do
  docker compose logs -f --no-log-prefix "$SERVICE"
  sleep 2
done
