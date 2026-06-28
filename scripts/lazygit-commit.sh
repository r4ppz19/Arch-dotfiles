#!/bin/bash

# Integrates Lazygit with Neovim
# for seamless commit workflows.
#
# See: nvim/lua/plugins/snacks.lua

nvr -cc close \
  --remote-tab-wait \
  +'setlocal bufhidden=wipe' \
  +'autocmd BufWipeout <buffer> lua vim.schedule(function() Snacks.lazygit() end)' \
  "$@"
