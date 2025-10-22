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

-- vertical help split
autocmd("BufWinEnter", {
  pattern = "*.txt",
  callback = function()
    if vim.bo.buftype == "help" then
      vim.cmd.wincmd "L"
    end
  end,
})

-- copilot chat
autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})

-- Wraping
autocmd("FileType", {
  pattern = { "text" },
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
    local exclude = { "markdown", "gitcommit", "txt", "text", "help" }
    if vim.tbl_contains(exclude, vim.bo.filetype) then
      return
    end
    -- Only trim if there are trailing spaces
    local line_count = vim.api.nvim_buf_line_count(0)
    for i = 1, line_count do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
      if line:match "%s+$" then
        local save_cursor = vim.fn.getpos "."
        vim.cmd [[%s/\s\+$//e]]
        vim.fn.setpos(".", save_cursor)
        break
      end
    end
  end,
})
