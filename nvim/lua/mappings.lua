require "nvchad.mappings"

local map = vim.keymap.set

-- Resize windows using Ctrl + Arrow keys
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Copilot mappings
map('n', '<leader>cc', ':CopilotChatOpen<CR>', { desc = 'Open CopilotChat' })
map('x', '<leader>cc', ':CopilotChatInPlace<CR>', { desc = 'Open CopilotChat InPlace' })

-- Save the current file in normal, insert, and visual modes with Ctrl+s
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- Move selected lines down in visual mode
map("v", "<S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "<S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Scroll half-page down and center cursor vertically in normal mode
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

-- After searching, pressing 'n' repeats search and centers the cursor vertically
map("n", "n", "nzzzv", { desc = "Next search result and center cursor" })

-- After searching, pressing 'N' repeats search backwards and centers cursor
map("n", "N", "Nzzzv", { desc = "Previous search result and center cursor" })

-- In visual mode, indent right and keep selection active with '> & <'
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })
