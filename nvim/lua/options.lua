require "nvchad.options"

-- add yours here!
-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!
-- Resize windows using Ctrl + Arrow keys

o.wrap = false
o.relativenumber = true
o.scrolloff = 8

