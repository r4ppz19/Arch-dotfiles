local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif", "*.bmp", "*.svg" },
  callback = function(args)
    vim.fn.jobstart({ "imv", args.file }, { detach = true })

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.api.nvim_buf_delete(args.buf, { force = true })
      end
    end)
  end,
})
autocmd("BufReadPost", {
  pattern = { "*.pdf", "*.epub" },
  callback = function(args)
    vim.fn.jobstart({ "okular", args.file }, { detach = true })
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.api.nvim_buf_delete(args.buf, { force = true })
      end
    end)
  end,
})

-- This is better then annoying error msg when closing it
autocmd("WinEnter", {
  callback = function()
    if vim.bo.filetype == "copilot-chat" and #vim.api.nvim_list_wins() == 1 then
      vim.cmd("quit")
    end
  end,
})

autocmd({
  "BufEnter",
  "CursorHold",
  "CursorHoldI",
  "FocusGained",
}, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

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
      vim.cmd.wincmd("L")
    end
  end,
})

-- copilot chat
autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = false
    vim.wo.conceallevel = 0
    vim.wo.winfixwidth = true
    vim.wo.winfixbuf = true
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
