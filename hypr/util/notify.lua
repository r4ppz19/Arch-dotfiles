local M = {}

-- notify-send lua wrapper

local function shell_quote(val)
  if type(val) ~= "string" then
    return tostring(val)
  end
  return "'" .. string.gsub(val, "'", "'\\''") .. "'"
end

function M.send(summary, body, config)
  if not summary or summary == "" then
    error("notify.send: 'summary' parameter is required.")
  end

  config = config or {}
  local cmd_parts = { "notify-send" }

  local flag_map = {
    timeout = "-t",
    app_name = "-a",
    icon = "-i",
    urgency = "-u",
    category = "-c",
    replace_id = "-r",
  }

  for key, flag in pairs(flag_map) do
    if config[key] then
      table.insert(cmd_parts, string.format("%s %s", flag, shell_quote(config[key])))
    end
  end

  if config.transient == true then
    table.insert(cmd_parts, "-e")
  end

  table.insert(cmd_parts, shell_quote(summary))
  if body and body ~= "" then
    table.insert(cmd_parts, shell_quote(body))
  end

  local final_cmd = table.concat(cmd_parts, " ")
  hl.exec_cmd(final_cmd)
end

return M
