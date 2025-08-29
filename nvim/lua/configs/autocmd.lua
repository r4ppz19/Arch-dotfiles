local api = vim.api

-- Indentation
local four_space_langs = { "python", "java", "rust" }
api.nvim_create_autocmd("FileType", {
	callback = function()
		local ft = vim.bo.filetype
		if vim.tbl_contains(four_space_langs, ft) then
			vim.bo.tabstop = 4
			vim.bo.shiftwidth = 4
			vim.bo.softtabstop = 4
		else
			vim.bo.tabstop = 2
			vim.bo.shiftwidth = 2
			vim.bo.softtabstop = 2
		end
		vim.bo.expandtab = true
	end,
})

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function()
		local exclude = { "markdown", "gitcommit" }
		if vim.tbl_contains(exclude, vim.bo.filetype) then
			return
		end
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- From nvchad default
local autocmd = vim.api.nvim_create_autocmd
-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

		if not vim.g.ui_entered and args.event == "UIEnter" then
			vim.g.ui_entered = true
		end

		if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
			vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
			vim.api.nvim_del_augroup_by_name("NvFilePost")

			vim.schedule(function()
				vim.api.nvim_exec_autocmds("FileType", {})

				if vim.g.editorconfig then
					require("editorconfig").config(args.buf)
				end
			end)
		end
	end,
})
