#!/usr/bin/env bash

if ! pgrep -x "obs" >/dev/null; then
  obs --minimize-to-tray &
  sleep 2
fi

obs-cmd recording toggle &
