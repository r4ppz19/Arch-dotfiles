local M = {}

-- Recursively collect all file paths from a directory
local function collect_files_from_directory(dir_path)
  local files = {}
  local all_items = vim.fn.globpath(dir_path, "**/*", false, true)

  for _, item in ipairs(all_items) do
    -- Only include files, not directories
    if vim.fn.isdirectory(item) == 0 and vim.fn.filereadable(item) == 1 then
      table.insert(files, item)
    end
  end

  return files
end

-- Convert node to list of file paths (handles both files and folders)
local function node_to_file_paths(node)
  local paths = {}
  if not node then
    return paths
  end
  if vim.fn.isdirectory(node.absolute_path) == 1 then
    paths = collect_files_from_directory(node.absolute_path)
  else
    table.insert(paths, node.absolute_path)
  end

  return paths
end

-- Map a key in nvim-tree to send selected/marked files to CopilotChat
function M.send_to_copilotchat()
  local api = require("nvim-tree.api")
  local chat = require("CopilotChat")

  -- Try marked nodes first, fallback to node under cursor
  local paths = {}
  local marked = api.marks.list()

  if #marked > 0 then
    for _, node in ipairs(marked) do
      local file_paths = node_to_file_paths(node)
      for _, path in ipairs(file_paths) do
        table.insert(paths, path)
      end
    end
  else
    local node = api.tree.get_node_under_cursor()
    if node then
      local file_paths = node_to_file_paths(node)
      for _, path in ipairs(file_paths) do
        table.insert(paths, path)
      end
    end
  end

  if #paths == 0 then
    vim.notify("No files selected in nvim-tree", vim.log.levels.WARN)
    return
  end

  -- Build #file:path lines for CopilotChat
  local lines = {}
  for _, path in ipairs(paths) do
    local cwd = vim.fn.getcwd()
    if vim.startswith(path, cwd) then
      path = vim.fn.fnamemodify(path, ":.")
    end
    table.insert(lines, "#file:" .. path)
  end

  chat.open()

  -- Schedule to ensure chat buffer is ready
  vim.schedule(function()
    vim.api.nvim_put(lines, "l", true, true)
    vim.cmd("normal! G")
  end)

  -- Clear marks after sending
  api.marks.clear()

  vim.notify(string.format("Added %d file(s) to CopilotChat", #lines), vim.log.levels.INFO)

  api.tree.close()
end

function M.on_attach(bufnr)
  local map = require("utils.map")
  map("n", "<C-a>", M.send_to_copilotchat, { desc = "Add marked file to the CopilotChat as context" }, bufnr)
end

return M
