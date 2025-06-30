local map = vim.keymap.set

map({ "n", "v" }, "<S-Left>", "b", { desc = "Move to the beginning of the word (like 'b')" })
map({ "n", "v" }, "<S-Right>", "e", { desc = "Move to the end of the word (like 'e')" })

map("i", "<S-Left>", "<C-o>b", { desc = "Move to the beginning of the word in insert mode" })
map("i", "<S-Right>", "<C-o>e", { desc = "Move to the end of the word in insert mode" })

map({ "n", "v" }, "<S-Up>", "<C-u>", { desc = "Scroll half a page up" })
map({ "n", "v" }, "<S-Down>", "<C-d>", { desc = "Scroll half a page down" })
map("i", "<S-Up>", "<C-o><C-u>", { desc = "Scroll half a page up in insert mode" })
map("i", "<S-Down>", "<C-o><C-d>", { desc = "Scroll half a page down in insert mode" })

map("n", "<C-Down>", "<C-e>", { desc = "Scroll window down one line" })
map("n", "<C-Up>", "<C-y>", { desc = "Scroll window up one line" })

map("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
map("n", "x", '"_x', { desc = "Delete char without copy to register" })

map("n", "<C-j>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-k>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-h>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-l>", ":vertical resize +2<CR>", { desc = "Increase window width" })

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- map("v", "<S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
-- map("v", "<S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

-- PLUGINS
map({ "n", "x" }, "<leader>pf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })
map("n", "<leader>pm", "<cmd>MarkdownPreview<cr>", { desc = "Makrdown preview" })
map("n", "<leader>pls", "<cmd>LiveServerStart<CR>", { desc = "Live Preview Start" })
map("n", "<leader>plx", "<cmd>LiveServerStop<CR>", { desc = "Live Preview Stop" })

-- TELESCOPE
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope: find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope: help page" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Telescope: find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope: find oldfiles" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Telescope pick: hidden term" })
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

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- TERMINAL
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

map("n", "<leader>th", function()
	require("nvchad.term").new({ pos = "sp" })
end, { desc = "terminal new horizontal term" })

map("n", "<leader>tv", function()
	require("nvchad.term").new({ pos = "vsp" })
end, { desc = "terminal new vertical term" })
-- toggleable
map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })
