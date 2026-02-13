return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = function()
    local languages = {
      "luadoc",
      "printf",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "query",

      "sql",
      "lua",
      "bash",
      "java",
      "rust",
      "python",
      "c",
      "cpp",
      "hyprlang",

      "yaml",
      "toml",
      "xml",
      "json",

      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",

      "diff",
      "git_config",
      "gitcommit",
      "git_rebase",
      "gitignore",
      "gitattributes",
      "regex",
    }
    require("nvim-treesitter").install(languages)
  end,
  config = function()
    -- Enable highlighting automatically for all buffers where a parser exists
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
      callback = function(args)
        local buf = args.buf
        -- Check if we have a parser for the current filetype
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype) or vim.bo[buf].filetype

        -- Try to start highlighting
        local ok, _ = pcall(vim.treesitter.start, buf, lang)

        -- If highlighting started successfully, set up indentation
        if ok then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
