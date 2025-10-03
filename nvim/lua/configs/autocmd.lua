require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Indentation
local four_space_langs = { "python", "java", "rust" }
autocmd("FileType", {
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

autocmd("BufEnter", {
  pattern = "copilot-chat",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
})

-- Wraping
autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

-- Hightlight yanking
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Trim trailing whitespace on save
autocmd("BufWritePre", {
  pattern = { "*" },
  callback = function()
    local exclude = { "markdown", "gitcommit" }
    if vim.tbl_contains(exclude, vim.bo.filetype) then
      return
    end
    local save_cursor = vim.fn.getpos "."
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos(".", save_cursor)
  end,
})
