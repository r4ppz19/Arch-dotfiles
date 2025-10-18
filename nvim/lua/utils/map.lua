local function map(mode, lhs, rhs, opts)
  if not mode then
    error "map: 'mode' is required"
  end
  if not lhs then
    error "map: 'lhs' (key) is required"
  end
  if not rhs then
    error "map: 'rhs' (action) is required"
  end

  opts = opts or {}
  opts.noremap = true
  opts.silent = true

  vim.keymap.set(mode, lhs, rhs, opts)
end

return map
