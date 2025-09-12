#!/bin/bash

ZOOM_STEP=1.5
MIN_ZOOM=1
MAX_ZOOM=20

ZOOM_IN_FACTOR=$ZOOM_STEP
ZOOM_OUT_FACTOR=$(awk "BEGIN {print 1/$ZOOM_STEP}")

current=$(hyprctl getoption cursor:zoom_factor -j | jq -r '.float')

case "$1" in
in)
  new=$(awk "BEGIN {val=$current * $ZOOM_IN_FACTOR; if (val > $MAX_ZOOM) val=$MAX_ZOOM; print val}")
  ;;
out)
  new=$(awk "BEGIN {val=$current * $ZOOM_OUT_FACTOR; if (val < $MIN_ZOOM) val=$MIN_ZOOM; print val}")
  ;;
*)
  echo "Usage: $0 {in|out}"
  exit 1
  ;;
esac

hyprctl -q keyword cursor:zoom_factor "$new"
