---@diagnostic disable: undefined-global
return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      opts = {
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
        keymaps = {
          view = {
            { "n", "<tab>", false },
            { "n", "<s-tab>", false },

            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<M-e>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle Explorer" } },
          },
          file_panel = {
            { "n", "<tab>", false },
            { "n", "<s-tab>", false },

            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<M-e>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle Explorer" } },
            { "n", "R", "<cmd>DiffviewRefresh<cr>", { desc = "Refresh" } },
          },
          file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<tab>", false },
            { "n", "<s-tab>", false },
          },
        },
      },
    },
  },
  event = "VeryLazy",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "" },
      untracked = { text = "┆" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = false,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 200,
    max_file_length = 10000,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },

  config = function(_, opts)
    require("gitsigns").setup(opts)
    local map = require("utils.map")

    map("n", "<M-g>", function()
      Snacks.lazygit.open()
    end, { desc = "Lazygit (Snacks)" })

    map("n", "<leader>gg", function()
      Snacks.lazygit.open()
    end, { desc = "Lazygit (Snacks)" })

    -- gitsign navigation
    map("n", "]c", function()
      require("gitsigns").nav_hunk("next")
    end, { desc = "Next Git Hunk (GitSign)" })
    map("n", "[c", function()
      require("gitsigns").nav_hunk("prev")
    end, { desc = "Previous Git Hunk (GitSign)" })

    -- stage hunk/buffer
    map("n", "<leader>gs", function()
      require("gitsigns").stage_hunk()
    end, { desc = "Stage Hunk (GitSign)" })
    map("n", "<leader>gS", function()
      require("gitsigns").stage_buffer()
    end, { desc = "Stage Buffer (GitSign)" })

    -- reset hunk/buffer
    map("n", "<leader>gr", function()
      require("gitsigns").reset_hunk()
    end, { desc = "Reset Hunk (GitSign)" })
    map("n", "<leader>gR", function()
      require("gitsigns").reset_buffer()
    end, { desc = "Reset Buffer (GitSign)" })

    -- preview changes/blame
    map("n", "<leader>gp", function()
      require("gitsigns").preview_hunk()
    end, { desc = "Preview Hunk (GitSign)" })
    map("n", "<leader>gP", function()
      require("gitsigns").preview_hunk_inline()
    end, { desc = "Preview Hunk Inline (GitSign)" })
    map("n", "<leader>gb", function()
      require("gitsigns").blame_line({ full = true })
    end, { desc = "Blame Line (GitSign)" })

    map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Open Diffview History (Diffview)" })
    map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Open Diffview Current File History Diffview" })
    map("n", "<leader>gb", function()
      Snacks.picker.git_branches({
        confirm = function(picker, item)
          picker:close()
          if not item then
            return
          end

          -- quick git repo check
          if vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1] ~= "true" then
            vim.notify("Not in a git repository", vim.log.levels.ERROR)
            return
          end

          -- Save current buffer because Diffview reads files on disk
          if vim.bo.modified then
            vim.cmd("write")
          end

          -- helper: try multiple likely fields to find the real ref
          local function guess_ref(it)
            if not it then
              return nil
            end
            local function first_ok(...)
              for i = 1, select("#", ...) do
                local v = select(i, ...)
                if v and v ~= "" then
                  return v
                end
              end
              return nil
            end

            -- top-level common fields
            local top = first_ok(it.branch, it.name, it.ref, it.value, it.text)
            if top then
              return top
            end

            -- sometimes the raw object is nested under item.item
            if type(it.item) == "table" then
              local nested = first_ok(it.item.branch, it.item.name, it.item.ref, it.item.value, it.item.text)
              if nested then
                return nested
              end
            end

            -- fallback: tostring(item) if it's not a table
            if type(it) ~= "table" then
              return tostring(it)
            end
            return nil
          end

          local raw = guess_ref(item)
          if not raw then
            vim.notify("Could not determine branch name from picker item", vim.log.levels.ERROR)
            return
          end

          -- If the field is a formatted display line, take the first token (refs normally don't contain spaces)
          local ref = tostring(raw):match("^%s*([^%s]+)")
          if not ref or ref == "" then
            vim.notify("Could not extract branch token", vim.log.levels.ERROR)
            return
          end

          local safe_ref = vim.fn.shellescape(ref)
          local cmd = "DiffviewOpen HEAD.." .. safe_ref
          -- run it
          vim.cmd(cmd)
        end,
      })
    end, { desc = "Compare HEAD..Branch (Diffview + Snacks)" })
  end,
}
