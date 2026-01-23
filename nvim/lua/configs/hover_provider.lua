--- Strips markdown links from the provided lines,
--- replacing them with backticked text.
local function strip_links(lines)
  local out = {}
  for _, line in ipairs(lines) do
    -- This pattern looks for [text](jdt://...)
    -- It captures the text and swallows everything until the final ')'
    local cleaned = line:gsub("%[(.-)%]%(jdt://.-%)", "`%1`")

    -- Fallback for standard links that might remain
    cleaned = cleaned:gsub("%[(.-)%]%b()", "`%1`")

    table.insert(out, cleaned)
  end
  return out
end

--- Pads each line with leading and trailing spaces,
--- and adds empty lines at the start and end.
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

      -- Apply transformations
      all_lines = strip_links(all_lines)
      all_lines = pad_lines(all_lines)

      if vim.tbl_isempty(all_lines) then
        done(false)
        return
      end

      done({ lines = all_lines, filetype = "markdown" })
    end)
  end,
}
