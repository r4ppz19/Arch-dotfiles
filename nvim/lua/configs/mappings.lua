-- I use arrow keys not hjkl cause I am a fucking weirdo

local map = require("utils.map")

----------------------------------------
-- Personal?
----------------------------------------
map({ "n", "v" }, "<S-Right>", "W", { desc = "Move Right like E" })
map({ "n", "v" }, "<S-Left>", "B", { desc = "Move Left like B" })

map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

map("n", "<M-Up>", "O", { desc = "Insert above" })
map("n", "<M-Down>", "o", { desc = "Insert below" })

map("n", "<M-a>", "u", { desc = "Undo" })
map("i", "<M-a>", "<C-o>u", { desc = "Undo (Insert)" })
map("v", "<M-a>", "u", { desc = "Undo (Visual)" })
map("n", "<M-d>", "<C-r>", { desc = "Redo" })
map("i", "<M-d>", "<C-o><C-r>", { desc = "Redo (Insert)" })
map("v", "<M-d>", "<C-r>", { desc = "Redo (Visual)" })

map("n", "<S-Up>", "<C-u>zz", { desc = "Scroll half a page up and center" })
map("n", "<S-Down>", "<C-d>zz", { desc = "Scroll half a page down and center" })
map("i", "<S-Up>", "<C-o><C-u><C-o>zz", { desc = "Scroll half a page up and center in insert mode" })
map("i", "<S-Down>", "<C-o><C-d><C-o>zz", { desc = "Scroll half a page down and center in insert mode" })

map({ "n", "v" }, "<C-Left>", "b", { desc = "Move to the beginning of the word" })
map({ "n", "v" }, "<C-Right>", "e", { desc = "Move to the end of the word" })
map("i", "<C-Left>", "<C-o>b", { desc = "Move to the beginning of the word in insert mode" })
map("i", "<C-Right>", "<C-o>e", { desc = "Move to the end of the word in insert mode" })

map("v", "<S-Up>", "{", { desc = "Jump to previous paragraph" })
map("v", "<S-Down>", "}", { desc = "Jump to next paragraph" })

map({ "n", "v" }, "<C-Down>", "<C-e>", { desc = "Scroll window down one line" })
map({ "n", "v" }, "<C-Up>", "<C-y>", { desc = "Scroll window up one line" })
map("i", "<C-Down>", "<C-o><C-e>", { desc = "Scroll window down one line in insert mode" })
map("i", "<C-Up>", "<C-o><C-y>", { desc = "Scroll window up one line in insert mode" })

map({ "n", "v" }, "g<Down>", "<Cmd>wincmd j<CR>", { desc = "Move to window down" })
map({ "n", "v" }, "g<Up>", "<Cmd>wincmd k<CR>", { desc = "Move to window up" })
map({ "n", "v" }, "g<Right>", "<Cmd>wincmd l<CR>", { desc = "Move to window right" })
map({ "n", "v" }, "g<Left>", "<Cmd>wincmd h<CR>", { desc = "Move to window left" })

map({ "n", "v" }, "<S-M-Down>", ":resize +2<CR>", { desc = "Increase window height" })
map({ "n", "v" }, "<S-M-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
map({ "n", "v" }, "<S-M-Right>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map({ "n", "v" }, "<S-M-Left>", ":vertical resize +2<CR>", { desc = "Increase window width" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("n", "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("v", "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("i", "<C-s>", "<C-o>:write<CR>", { desc = "Save file" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

map("t", "<C-q>", "<C-\\><C-N>", { desc = "Escape terminal mode" })

map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

--------------------------------------------------
-- Disabled/Change defaults cause why not
--------------------------------------------------
map("n", "<C-z>", "<nop>", { desc = "Disable suspend" })
map("n", "ZZ", "<nop>", { desc = "Disable accidental save and quit (ZZ)" })
map("n", "ZQ", "<nop>", { desc = "Disable accidental quit (ZQ)" })

map("n", "s", "<nop>", { desc = "Disable s to avoid accidental edits" })
map("v", "s", '"_s', { desc = "Substitute without yanking (visual)" })
map("n", "S", '"_S', { desc = "Substitute line without yanking (normal)" })

map("n", "q", "<Nop>", { desc = "Disable recording macro (q)" })
map("n", "Q", "<Nop>", { desc = "Disable Ex mode (Q)" })

map("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
map({ "n", "v" }, "x", '"_x', { desc = "Delete character without yanking" })
map("n", "c", '"_c', { desc = "Change text without yanking" })
-- map("n", "d", '"_d', { desc = "Delete text without yanking" })

map({ "n", "v" }, "!", "^", { desc = "Jump to first non-blank character of the line" })
map({ "n", "v" }, "@", "g_", { desc = "Jump to last non-blank character of line" })

map("n", "#", [[<Cmd>let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>]], { desc = "Highlight word (no jump)" })
map(
  "v",
  "#",
  [[y<Cmd>let @/ = '\V' . escape(@", '/\')<CR>:set hlsearch<CR>]],
  { desc = "Highlight selection (no jump)" }
)

-- I dont even know why I have this...
local marks = { "A", "B", "C", "D", "E" }
for i, mark in ipairs(marks) do
  map("n", "m" .. i, "m" .. mark, { desc = "Set global mark " .. mark })
  map("n", "g" .. i, "`" .. mark, { desc = "Exact jump to global mark " .. mark })
end

-- Open selected text as URL (portable)
-- (do I need this? idk)
local function create_open_url_function()
  local is_mac = vim.fn.has("mac") == 1
  local is_win = vim.fn.has("win32") == 1

  return function(url)
    url = vim.fn.trim(url or "")
    if url == "" then
      vim.notify("No URL selected", vim.log.levels.WARN)
      return
    end
    local cmd
    if is_mac then
      cmd = { "open", url }
    elseif is_win then
      cmd = { "cmd.exe", "/c", "start", "", url }
    else
      cmd = { "xdg-open", url }
    end
    vim.fn.jobstart(cmd, { detach = true })
  end
end

local open_url_portable = create_open_url_function()
map("v", "gx", function()
  vim.cmd([[normal! "vy]])
  local url = vim.fn.getreg('"')
  open_url_portable(url)
end, { desc = "Open selected text as URL" })

-------------------------------------------------------------
-- Plugins? (other keybinds are in the plugins lua files)
-------------------------------------------------------------
-- NVCHAD
map("n", "<leader>vc", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
map("n", "<leader>vt", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- UI
map("n", "<leader>um", "<cmd>Mason<CR>", { desc = "Mason UI" })
map("n", "<leader>ul", "<cmd>Lazy<CR>", { desc = "Lazy UI" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tX", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>t<Right>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>t<Left>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Buffers management
map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Buffer new" })
-- change buffer
map({ "n" }, "<M-Right>", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer goto next" })
map({ "n" }, "<M-Left>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer goto prev" })
-- move buffer
map({ "n" }, "<C-M-Right>", function()
  require("nvchad.tabufline").move_buf(1)
end, { desc = "move buffer to the right" })
map({ "n" }, "<C-M-Left>", function()
  require("nvchad.tabufline").move_buf(-1)
end, { desc = "move buffer to the left" })
-- close buffer
map("n", "<M-x>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })
map("n", "<S-M-X>", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "Close all buffers except current" })

-- Terminal
local term_utils = require("utils.terminal")
-- Floating Terminal
map({ "n", "t" }, "<A-w>", function()
  term_utils.toggle_tab_terminal({ pos = "float" })
end, { desc = "Toggle tab-scoped floating terminal" })
-- Horizontal Split Terminal
map({ "n", "t" }, "<A-s>", function()
  term_utils.toggle_tab_terminal({ pos = "sp", size = 0.6 })
end, { desc = "Toggle tab-scoped horizontal terminal" })
-- Vertical Split Terminal
map({ "n", "t" }, "<A-v>", function()
  term_utils.toggle_tab_terminal({ pos = "vsp", size = 0.8 })
end, { desc = "Toggle tab-scoped vertical terminal" })
map("n", "<A-t>", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "New Terminal Buffer" })

--------------------------------------------------------------------------
-- Ill put the proper binds here once I learned proper vim key bindings
-- ( Very unlikely )
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line up" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line down (insert mode)" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line up (insert mode)" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
