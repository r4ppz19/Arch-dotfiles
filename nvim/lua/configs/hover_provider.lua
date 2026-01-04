local function clean_markdown_links(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("%[([^%]]+)%]%([^%)]+%)", "%1")
    cleaned = cleaned:gsub("%s+", " ")
    cleaned = cleaned:gsub("^%s*(.-)%s*$", "%1")
    table.insert(out, cleaned)
  end
  return out
end

local function trim_empty_lines(lines)
  local first, last = 1, #lines
  while first <= last and lines[first]:match("^%s*$") do
    first = first + 1
  end
  while last >= first and lines[last]:match("^%s*$") do
    last = last - 1
  end
  local out = {}
  for i = first, last do
    table.insert(out, lines[i])
  end
  return out
end

local function pad_lines(lines)
  local out = { "" }
  for _, l in ipairs(lines) do
    table.insert(out, "  " .. l)
  end
  table.insert(out, "")
  return out
end

return {
  name = "Hover Docs",
  priority = 1000,
  enabled = function(_)
    return true
  end,
  execute = function(_, done)
    vim.lsp.buf_request(
      0,
      "textDocument/hover",
      vim.lsp.util.make_position_params(0, "utf-16"),
      function(err, result, _, _)
        if err or not (result and result.contents) then
          done(false)
          return
        end
        local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        lines = clean_markdown_links(lines)
        lines = trim_empty_lines(lines)
        lines = pad_lines(lines)
        if vim.tbl_isempty(lines) then
          done(false)
          return
        end
        done({ lines = lines, filetype = "markdown" })
      end
    )
  end,
}
