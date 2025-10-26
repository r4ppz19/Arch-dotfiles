local opt = vim.opt
local o = vim.o
local g = vim.g

o.autoread = true

o.relativenumber = false
o.scrolloff = 8
o.sidescroll = 1
o.sidescrolloff = 8
o.wrap = false
o.linebreak = true
o.breakindent = true
o.showbreak = " "

o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"
o.equalalways = false

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.autoindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250          -- Reduce from default 4000ms to 250ms for quicker updates
o.lazyredraw = true         -- Not redraw while running macros
o.ttyfast = true            -- Assume fast terminal
o.fdo = "search,tag,insert,undo"  -- Reduce file I/O
o.termguicolors = true      -- Use true colors
o.inccommand = "nosplit"    -- Instead of "split" to avoid creating splits during search
o.hidden = true             -- Allow more flexible buffer handling
o.belloff = "all"           -- Turn off bell completely
o.cmdheight = 1             -- Minimal command line height
o.synmaxcol = 200           -- Limit syntax highlighting to 200 columns for performance

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
