local function dedent(str)
  str = str:gsub("^\n", "")
  local indent = str:match "\n([ \t]+)%S"
  if not indent then
    return str
  end
  return str:gsub("\n" .. indent, "\n")
end

return dedent
