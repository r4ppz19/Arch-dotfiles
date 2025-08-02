#!/bin/bash
set -euo pipefail

MINUTES="$1"
TOTAL_SECONDS=$(( MINUTES * 60 ))

orig_stty=$(stty -g)
stty -echo -icanon
cleanup() {
  stty "$orig_stty"
  printf "\n"
}
trap cleanup EXIT INT TERM

for (( i = 1; i <= TOTAL_SECONDS; i++ )); do
  printf "\r%02d:%02d" $(( (TOTAL_SECONDS - i) / 60)) $(( (TOTAL_SECONDS - i) % 60))
  sleep 1
done

printf "\n\n⏰ Timer Done."
notify-send -u critical "⏰ Timer Done" "Your timer has finished."
