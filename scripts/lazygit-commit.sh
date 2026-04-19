#!/usr/bin/env bash

# Hide the float, open a tab, set wipeout, and schedule the Lazygit restore
nvr -cc close \
  --remote-tab-wait \
  +'setlocal bufhidden=wipe' \
  +'autocmd BufWipeout <buffer> lua vim.schedule(function() Snacks.lazygit() end)' \
  "$@"
