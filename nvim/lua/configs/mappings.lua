---@diagnostic disable: undefined-global

-- I use arrow keys not hjkl cause I am a fucking weirdo

local map = require("utils.map")

----------------------------------------
-- Personal?
----------------------------------------
map("n", "<C-W>q", function()
  if vim.fn.winnr("$") > 1 then
    vim.cmd("q")
  else
    vim.notify("Cannot close the last window", vim.log.levels.WARN)
  end
end, { desc = "Close window safely" })

map("n", "<leader>ow", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping" })

map({ "n", "v" }, "<S-Right>", "E", { desc = "Move Right like E" })
map({ "n", "v" }, "<S-Left>", "B", { desc = "Move Left like B" })

map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

map("n", "<M-Up>", "O", { desc = "Insert above" })
map("n", "<M-Down>", "o", { desc = "Insert below" })
map("i", "<M-Up>", "<C-o>O", { desc = "Insert above" })
map("i", "<M-Down>", "<C-o>o", { desc = "Insert below" })

map("n", "<M-a>", "u", { desc = "Undo" })
map("i", "<M-a>", "<C-o>u", { desc = "Undo (Insert)" })
map("v", "<M-a>", "u", { desc = "Undo (Visual)" })
map("n", "<M-d>", "<C-r>", { desc = "Redo" })
map("i", "<M-d>", "<C-o><C-r>", { desc = "Redo (Insert)" })
map("v", "<M-d>", "<C-r>", { desc = "Redo (Visual)" })

map("n", "<S-Up>", "<C-u>", { desc = "Scroll half a page up and center" })
map("n", "<S-Down>", "<C-d>", { desc = "Scroll half a page down and center" })
map("i", "<S-Up>", "<C-o><C-u><C-o>", { desc = "Scroll half a page up and center in insert mode" })
map("i", "<S-Down>", "<C-o><C-d><C-o>", { desc = "Scroll half a page down and center in insert mode" })

-- These gets weird once animation scroll (from Snacks) is enabled
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
-- LSP related
--------------------------------------------------

-- map("n", "gR", "<cmd>Lspsaga finder ref+def+imp<CR>", {
--   desc = "Find References (including def and imp)",
-- })
-- map("n", "gr", "<cmd>Lspsaga finder<CR>", {
--   desc = "Find References",
-- })

-- map("n", "gr", function()
--   Snacks.picker.lsp_references({
--     auto_confirm = false,
--     title = "References",
--     layout = {
--       preview = "main",
--       layout = {
--         backdrop = false,
--         width = 40,
--         min_width = 40,
--         height = 0,
--         position = "right",
--         border = "none",
--         box = "vertical",
--         { win = "list", border = "none" },
--         { win = "preview", title = "{preview}", height = 0.4, border = "top" },
--       },
--     },
--   })
-- end, { desc = "LSP References (Snacks)" })
--
map("n", "gr", function()
  Snacks.picker.lsp_references({
    auto_confirm = false,
    title = "References",
    layout = {
      layout = {
        box = "vertical",
        row = -1,
        width = 0,
        height = 0.4,
        border = "top",
        {
          box = "horizontal",
          {
            win = "list",
            border = "none",
          },
          {
            win = "preview",
            title = "{preview}",
            width = 0.5,
            border = "left",
          },
        },
      },
    },
  })
end, { desc = "LSP References (Snacks)" })

map("n", "gd", function()
  Snacks.picker.lsp_definitions()
end, { desc = "Goto [d]efinition (Snacks)" })

map("n", "gI", function()
  Snacks.picker.lsp_implementations()
end, { desc = "Goto [I]mplementation (Snacks)" })

map("n", "gy", function()
  Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition (Snacks)" })

map("n", "ge", function()
  Snacks.picker.lsp_declarations()
end, { desc = "Goto D[e]claration (Snacks)" })

map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", {
  desc = "Peek Definition",
})
map("n", "gT", "<cmd>Lspsaga peek_type_definition<CR>", {
  desc = "Peek Type Definition",
})
map("n", "<S-C-Down>", "<cmd>Lspsaga peek_definition<CR>", {
  desc = "Peek Definition",
})

map({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", {
  desc = "Code Actions",
})

map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", {
  desc = "Rename Symbol",
})

-- Diagnostic Show
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {
  desc = "Previous Diagnostic",
})
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", {
  desc = "Next Diagnostic",
})

map("n", "<leader>lD", "<cmd>Lspsaga show_line_diagnostics<CR>", {
  desc = "Show Line Diagnostics",
})
map("n", "<leader>ld", "<cmd>Lspsaga show_buf_diagnostics<CR>", {
  desc = "Show Buffer Diagnostics",
})
map("n", "<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", {
  desc = "Show Workspace Diagnostics",
})

map("n", "<leader>li", function()
  Snacks.picker.lsp_incoming_calls({
    auto_confirm = false,
    title = "References",
    layout = {
      preview = "main",
      layout = {
        backdrop = false,
        width = 40,
        min_width = 40,
        height = 0,
        position = "right",
        border = "none",
        box = "vertical",
        { win = "list", border = "none" },
        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
      },
    },
  })
end, {
  desc = "Incoming Calls",
})

map("n", "<leader>lo", function()
  Snacks.picker.lsp_outgoing_calls({
    auto_confirm = false,
    title = "References",
    layout = {
      preview = "main",
      layout = {
        backdrop = false,
        width = 40,
        min_width = 40,
        height = 0,
        position = "right",
        border = "none",
        box = "vertical",
        { win = "list", border = "none" },
        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
      },
    },
  })
end, {
  desc = "Outgoing Calls",
})

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

-- Neovim 0.10+ has a built-in provider for this
vim.keymap.set("n", "gx", function()
  local url = vim.fn.expand("<cfile>")
  if url:match("https?://") then
    vim.ui.open(url)
  else
    vim.notify("Not a valid URL under cursor", vim.log.levels.ERROR)
  end
end, { desc = "Open URL under cursor" })

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

-- BUFFERS MANAGEMENT
-- Helper function to safely execute buffer commands
local function safe_buf_action(action)
  return function()
    if vim.wo.winfixbuf then
      return
    end
    local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
    if is_floating then
      return
    end
    pcall(action)
  end
end

map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Buffer new" })

-- change buffer (Protected)
map(
  { "n" },
  "<M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").next()
  end),
  { desc = "Buffer goto next" }
)
map(
  { "n" },
  "<M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").prev()
  end),
  { desc = "Buffer goto prev" }
)

-- move buffer (Protected)
map(
  { "n" },
  "<C-M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(1)
  end),
  { desc = "move buffer to the right" }
)
map(
  { "n" },
  "<C-M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(-1)
  end),
  { desc = "move buffer to the left" }
)

-- close buffer
map("n", "<M-q>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })
map("n", "<S-M-Q>", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "Close all buffers except current" })

map("n", "<M-x>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })
map("n", "<S-M-X>", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "Close all buffers except current" })

-- TERMINAL MANAGEMENT
local focus_main_window = require("utils.focus_main_window")

-- Keymaps
map({ "n", "t" }, "<A-w>", function()
  focus_main_window()
  require("nvchad.term").toggle({ pos = "float", id = "float_term" })
end, { desc = "Toggle Floating Terminal" })

map({ "n", "t" }, "<M-S-d>", function()
  focus_main_window()
  local term = require("nvchad.term")
  term.toggle({
    pos = "float",
    id = "lazydocker_float",
    float_opts = {
      row = 0.05,
      col = 0.05,
      width = 0.9,
      height = 0.8,
      border = "single",
    },
    cmd = "lazydocker",
  })

  -- map q to close/toggle the terminal (not LazyDocker)
  local buf = vim.api.nvim_get_current_buf()
  map("t", "q", function()
    term.toggle({ id = "lazydocker_float" })
  end, { buffer = buf })
end, { desc = "Toggle LazyDocker" })

map({ "n", "t" }, "<A-s>", function()
  focus_main_window()
  require("nvchad.term").toggle({ pos = "sp", id = "horizontal_term", size = 0.6 })
end, { desc = "Toggle Horizontal Terminal" })

map({ "n", "t" }, "<A-v>", function()
  focus_main_window()
  require("nvchad.term").toggle({ pos = "vsp", id = "vertical_term", size = 0.5 })
end, { desc = "Toggle Vertical Terminal" })

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
