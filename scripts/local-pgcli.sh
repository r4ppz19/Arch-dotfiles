#!/bin/bash
SERVICE_NAME="$1"

# Get the actual Container ID/Name from the Service Name
CONTAINER_ID=$(docker compose ps -q "$SERVICE_NAME")

if [[ -z "$CONTAINER_ID" ]]; then
  echo "ERROR: No running container found for service: $SERVICE_NAME"
  exit 1
fi

# Extract Port Mapping
MAPPED_PORT=$(docker port "$CONTAINER_ID" 5432 | head -n 1 | awk -F: '{print $NF}')

if [[ -z "$MAPPED_PORT" ]]; then
  echo "ERROR: Service $SERVICE_NAME (ID: $CONTAINER_ID) is not exposing port 5432."
  echo "Ensure 'ports: - 5432:5432' is in your docker-compose.yml"
  exit 1
fi

# Extract Credentials
DB_USER=$(docker inspect "$CONTAINER_ID" --format '{{range .Config.Env}}{{println .}}{{end}}' | grep '^POSTGRES_USER=' | cut -d'=' -f2)
DB_PASS=$(docker inspect "$CONTAINER_ID" --format '{{range .Config.Env}}{{println .}}{{end}}' | grep '^POSTGRES_PASSWORD=' | cut -d'=' -f2)
DB_NAME=$(docker inspect "$CONTAINER_ID" --format '{{range .Config.Env}}{{println .}}{{end}}' | grep '^POSTGRES_DB=' | cut -d'=' -f2)

echo "Connecting to $SERVICE_NAME on port $MAPPED_PORT as $DB_USER..."

export PGPASSWORD="$DB_PASS"
pgcli -h localhost -p "$MAPPED_PORT" -U "$DB_USER" -d "$DB_NAME"
