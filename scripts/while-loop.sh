#!/bin/bash
set -euo pipefail

CMD="$1"

while true; do
  $CMD
  printf "\nCan't escape :(\n"
  sleep 1
done
