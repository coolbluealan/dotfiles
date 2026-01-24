return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~_" },
      untracked = { text = "┆" },
    },
    on_attach = function()
      vim.keymap.set("n", "]g", function()
        require("gitsigns").nav_hunk("next")
      end, { buffer = true })
      vim.keymap.set("n", "[g", function()
        require("gitsigns").nav_hunk("prev")
      end, { buffer = true })
      vim.keymap.set("n", "<C-g>", function()
        require("gitsigns").preview_hunk()
      end, { buffer = true })
    end,
  },
}
