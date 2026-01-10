--- Cleans markdown links from a list of lines.
-- Replaces [Link Text](url) with Link Text and trims trailing whitespace.
local function clean_markdown_links(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local cleaned = line:gsub("%[([^%]]+)%]%([^%)]+%)", "%1")
    cleaned = cleaned:gsub("%s+$", "")
    table.insert(out, cleaned)
  end
  return out
end

--- Processes and normalizes markdown documentation lines for hover display.
-- Handles code blocks, list formatting, and removes redundant whitespace.
local function process_docs(lines)
  local normalized = {}
  for _, line in ipairs(lines) do
    for s in string.gmatch(line .. "\n", "([^\n]*)\n") do
      table.insert(normalized, s)
    end
  end

  local out = {}
  local in_code_block = false

  local list_pat = "^%s*[%*%-%+]%s+"
  local numbered_pat = "^%s*%d+[%.%)]%s+"
  local top_level_pat = "^%s?[%*%-%+]%s+"

  for i = 1, #normalized do
    local line = normalized[i]
    local prev_line = out[#out] or ""

    if line:match("^%s*```") then
      in_code_block = not in_code_block
      table.insert(out, line)
      goto continue
    end

    if in_code_block then
      table.insert(out, line)
      goto continue
    end

    local is_empty = line:match("^%s*$")
    local prev_is_list = prev_line:match(list_pat) or prev_line:match(numbered_pat)

    -- Force blank line before a new TOP-LEVEL list item group
    if line:match(top_level_pat) and prev_is_list then
      if not prev_line:match("^%s*$") then
        table.insert(out, "")
      end
    end

    -- Compact sub-items by skipping empty lines inside lists
    if is_empty and i < #normalized then
      local next_line = normalized[i + 1]
      local next_is_list = next_line:match(list_pat) or next_line:match(numbered_pat)

      if prev_is_list and next_is_list then
        goto continue
      end
    end

    -- Kill redundant whitespace
    if is_empty and prev_line:match("^%s*$") then
      goto continue
    end

    table.insert(out, line)
    ::continue::
  end
  return out
end

--- Pads each line in the input table with a leading and trailing space.
-- Adds an empty string at the start and end of the output.
local function pad_lines(lines)
  if #lines == 0 then
    return {}
  end
  local out = { "" }
  for _, l in ipairs(lines) do
    table.insert(out, " " .. l .. " ")
  end
  table.insert(out, "")
  return out
end

--- Removes duplicate non-empty lines from a list, preserving code block markers.
-- Lines that are empty or start code blocks (```), are always included.
local function deduplicate_lines(lines)
  local seen = {}
  local unique_lines = {}
  for _, line in ipairs(lines) do
    local is_code = line:match("^%s*```")
    if line ~= "" and not is_code then
      if not seen[line] then
        table.insert(unique_lines, line)
        seen[line] = true
      end
    else
      table.insert(unique_lines, line)
    end
  end
  return unique_lines
end

return {
  name = "Hover Docs",
  priority = 1000,
  enabled = function(bufnr)
    -- Only enable if there is an active LSP client
    return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
  end,

  execute = function(_, done)
    local params = vim.lsp.util.make_position_params(0, "utf-16")

    -- buf_request_all collects all responses before firing the callback
    vim.lsp.buf_request_all(0, "textDocument/hover", params, function(responses)
      local all_lines = {}
      local valid_result = false

      -- Iterate through all LSP responses
      for _, response in pairs(responses) do
        if response.result and response.result.contents then
          valid_result = true
          local client_lines = vim.lsp.util.convert_input_to_markdown_lines(response.result.contents)
          for _, line in ipairs(client_lines) do
            table.insert(all_lines, line)
          end
        end
      end

      if not valid_result then
        done(false)
        return
      end

      -- Apply custom filters to the aggregated results
      all_lines = deduplicate_lines(all_lines)
      all_lines = clean_markdown_links(all_lines)
      all_lines = process_docs(all_lines)
      all_lines = pad_lines(all_lines)

      if vim.tbl_isempty(all_lines) then
        done(false)
        return
      end

      done({ lines = all_lines, filetype = "markdown" })
    end)
  end,
}
