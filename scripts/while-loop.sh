#!/bin/bash
CMD="$1"

while true; do
  $CMD
  printf "\n\nTrying again....\n\n"
done
