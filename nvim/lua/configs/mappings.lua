local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Editor remaps/ built in
-- I use arrow keys not hjkl cause I am a fucking weirdo

map({ "n", "v" }, "Up", "k", { desc = "Move up" })
map({ "n", "v" }, "Down", "j", { desc = "Move down" })
map({ "n", "v" }, "Left", "h", { desc = "Move left" })
map({ "n", "v" }, "Right", "l", { desc = "Move right" })
map("i", "Up", "<C-o>k", { desc = "Move up" })
map("i", "Down", "<C-o>j", { desc = "Move down" })
map("i", "Left", "<C-o>h", { desc = "Move left" })
map("i", "Right", "<C-o>l", { desc = "Move right" })

map("n", "!", "%", { desc = "Jump to matching pair" })

map("n", "1", "^", { desc = "Jump to first non-blank character of the line" })
map("n", "2", "$", { desc = "Jump to end of line" })

map("v", "gx", function()
  vim.cmd [[normal! "vy]]
  local url = vim.fn.getreg '"'
  url = vim.fn.trim(url)
  if url ~= "" then
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  else
    vim.notify("No URL selected", vim.log.levels.WARN)
  end
end, { silent = true, desc = "Open selected text as URL" })

map("n", "q", "<Nop>")

map("n", "*", [[<Cmd>let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>]], { desc = "Highlight word (no jump)" })
map("n", "#", [[<Cmd>let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>]], { desc = "Highlight word (no jump)" })
map(
  "v",
  "*",
  [[y:let @/ = '\V'.escape(@", '/\').'\>'<CR>:set hlsearch<CR>]],
  { desc = "Highlight selection (no jump)" }
)
map(
  "v",
  "#",
  [[y:let @/ = '\V'.escape(@", '/\').'\>'<CR>:set hlsearch<CR>]],
  { desc = "Highlight selection (no jump)" }
)

map("i", "<C-h>", "<C-w>", { desc = "Make Ctrl+Backspace act as ctrl+w in insert mode" })

map({ "n", "v" }, "<C-Left>", "b", { desc = "Move to the beginning of the word" })
map({ "n", "v" }, "<C-Right>", "e", { desc = "Move to the end of the word" })
map("i", "<C-Left>", "<C-o>b", { desc = "Move to the beginning of the word in insert mode" })
map("i", "<C-Right>", "<C-o>e", { desc = "Move to the end of the word in insert mode" })
--
map({ "n", "v" }, "<S-Up>", "{zz", { desc = "Jump to previous paragraph (centered)" })
map({ "n", "v" }, "<S-Down>", "}zz", { desc = "Jump to next paragraph (centered)" })
map("i", "<S-Up>", "<C-o>{zz", { desc = "Jump to previous paragraph (centered) in insert mode" })
map("i", "<S-Down>", "<C-o>}zz", { desc = "Jump to next paragraph (centered) in insert mode" })
-- map({ "n", "v" }, "<S-Up>", "<C-u>", { desc = "Scroll half a page up" })
-- map({ "n", "v" }, "<S-Down>", "<C-d>", { desc = "Scroll half a page down" })
-- map("i", "<S-Up>", "<C-o><C-u>", { desc = "Scroll half a page up in insert mode" })
-- map("i", "<S-Down>", "<C-o><C-d>", { desc = "Scroll half a page down in insert mode" })

map("n", "<C-Down>", "<C-e>", { desc = "Scroll window down one line" })
map("n", "<C-Up>", "<C-y>", { desc = "Scroll window up one line" })
map("i", "<C-Down>", "<C-o><C-e>", { desc = "Scroll window down one line in insert mode" })
map("i", "<C-Up>", "<C-o><C-y>", { desc = "Scroll window up one line in insert mode" })

map("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
map("n", "x", '"_x', { desc = "Delete char without copy to register" })

map("n", "<C-j>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-k>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-h>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-l>", ":vertical resize +2<CR>", { desc = "Increase window width" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })
map("t", "<C-x>", "<C-\\><C-N>", { desc = "escape terminal mode" })

-- map("v", "<S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
-- map("v", "<S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- If I ever end up using hjkl (unlikely, since I use VSCode for serious work :p )
-- map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
-- map("i", "<C-e>", "<End>", { desc = "move end of line" })
-- map("i", "<C-h>", "<Left>", { desc = "move left" })
-- map("i", "<C-l>", "<Right>", { desc = "move right" })
-- map("i", "<C-j>", "<Down>", { desc = "move down" })
-- map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- NVCHAD
map("n", "<leader>nc", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
map("n", "<leader>nt", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- Toggleable terminal
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle {
    pos = "vsp",
    id = "vtoggleTerm",
    size = 0.3,
  }
end, { desc = "Toggle Vertical terminal" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle {
    pos = "sp",
    id = "htoggleTerm",
    size = 0.5,
  }
end, { desc = "Toggle horizontal terminal" })

map({ "n", "t" }, "<A-d>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "ftoggleTerm",
  }
end, { desc = "Toggle floating terminal" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "Buffer new" })

map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tm", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tM", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

map("n", "<leader><Right>", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer goto next" })

map("n", "<leader><Left>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer goto prev" })

-- map("n", "<S-Right>", function()
--   require("nvchad.tabufline").next()
-- end, { desc = "Buffer goto next" })
--
-- map("n", "<S-Left>", function()
--   require("nvchad.tabufline").prev()
-- end, { desc = "Buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })

local function close_all_buffers_but_current()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= current_buf and vim.bo[bufnr].buflisted then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end
vim.keymap.set("n", "<leader>X", close_all_buffers_but_current, { desc = "Buffers Close all " })
