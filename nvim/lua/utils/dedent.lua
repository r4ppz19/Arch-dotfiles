local function dedent(str)
  str = str:gsub("^%s*\n", ""):gsub("\n%s*$", "")
  local min_indent = nil
  for indent in str:gmatch("\n([ \t]*)%S") do
    if min_indent == nil or #indent < #min_indent then
      min_indent = indent
    end
  end
  if not min_indent or #min_indent == 0 then
    return str
  end
  return str:gsub("\n" .. min_indent, "\n")
end

return dedent
