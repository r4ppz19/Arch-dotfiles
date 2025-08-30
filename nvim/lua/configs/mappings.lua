local map = function(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = opts.noremap ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Editor remaps/ built in
map("n", "*", [[<Cmd>let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>]], { desc = "Highlight word (no jump)" })
map("n", "#", [[<Cmd>let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>]], { desc = "Highlight word (no jump)" })

map("i", "<C-h>", "<C-w>", { desc = "Make Ctrl+Backspace act as ctrl+w in insert mode" })

map({ "n", "v" }, "<C-Left>", "b", { desc = "Move to the beginning of the word" })
map({ "n", "v" }, "<C-Right>", "e", { desc = "Move to the end of the word" })

map("i", "<C-Left>", "<C-o>b", { desc = "Move to the beginning of the word in insert mode" })
map("i", "<C-Right>", "<C-o>e", { desc = "Move to the end of the word in insert mode" })

map({ "n", "v" }, "<S-Up>", "<C-u>", { desc = "Scroll half a page up" })
map({ "n", "v" }, "<S-Down>", "<C-d>", { desc = "Scroll half a page down" })
map("i", "<S-Up>", "<C-o><C-u>", { desc = "Scroll half a page up in insert mode" })
map("i", "<S-Down>", "<C-o><C-d>", { desc = "Scroll half a page down in insert mode" })

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

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })
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

-- PLUGINS
map({ "n", "x" }, "<leader>pf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })
map("n", "<leader>pm", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview" })
map("n", "<leader>pls", "<cmd>LiveServerStart<CR>", { desc = "Live Preview Start" })
map("n", "<leader>plx", "<cmd>LiveServerStop<CR>", { desc = "Live Preview Stop" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-- TELESCOPE
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope: find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope: help page" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Telescope: find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope: find oldfiles" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope: find files" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Telescope: command palette" })
map("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { desc = "Telescope: quickfix list" })
map("n", "<leader>fl", "<cmd>Telescope loclist<CR>", { desc = "Telescope: location list" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "Telescope: find all files" }
)
map("n", "<leader>fH", function()
	require("telescope.builtin").find_files({
		prompt_title = "Home Files",
		cwd = vim.fn.expand("~"),
		hidden = true,
		no_ignore = true,
		follow = true,
	})
end, { desc = "Telescope: find files from $HOME" })
map("n", "<leader>fgc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope: find in current buffer" })
map("n", "<leader>fgl", "<cmd>Telescope live_grep<CR>", { desc = "Telescope: live grep" })
map("n", "<leader>fgh", function()
	require("telescope.builtin").live_grep({
		prompt_title = "Grep in Home",
		cwd = vim.fn.expand("~"),
		additional_args = function()
			return { "--hidden", "--no-ignore" }
		end,
	})
end, { desc = "Telescope: grep in $HOME" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope: git commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope: git status" })

-- NVCHAD
map("n", "<leader>nc", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
map("n", "<leader>nt", function()
	require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- TERMINAL
map("n", "<leader>tf", "<cmd>Telescope terms<CR>", { desc = "Termianl: telescope hidden term" })
map({ "n", "t" }, "<leader>tp", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal: toggle popup term" })

map("n", "<leader>th", function()
	require("nvchad.term").new({ pos = "sp" })
end, { desc = "Terminal: new horizontal term" })
map("n", "<leader>tv", function()
	require("nvchad.term").new({ pos = "vsp" })
end, { desc = "Terminal: new vertical term" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "terminal toggleable horizontal term" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<tab>", function()
	require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })
map("n", "<S-tab>", function()
	require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })
map("n", "<leader>x", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })
