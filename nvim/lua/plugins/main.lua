return {
  "nvim-lua/plenary.nvim",

  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require("nvchad")
    end,
  },

  { "nvzone/volt", lazy = true },

  {
    "nvzone/menu",
    dependencies = { "nvzone/volt" },
    keys = {
      -- Keyboard-driven default menu
      -- {
      --   "<C-t>",
      --   function()
      --     require("menu").open "default"
      --   end,
      --   mode = "n",
      --   desc = "Open menu (default)",
      -- },

      -- Right-click context menu (normal/visual)
      {
        "<RightMouse>",
        function()
          require("menu.utils").delete_old_menus()
          vim.cmd.normal({ args = { "<RightMouse>" }, bang = true })
          local winid = vim.fn.getmousepos().winid
          if winid == 0 then
            winid = vim.api.nvim_get_current_win()
          end
          local buf = vim.api.nvim_win_get_buf(winid)
          local ft = vim.bo[buf].ft
          local options = (ft == "NvimTree") and "nvimtree" or "default"
          require("menu").open(options, { mouse = true })
        end,
        mode = { "n", "v" },
        desc = "Context menu (auto: default or NvimTree)",
      },
    },
  },

  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },
}
