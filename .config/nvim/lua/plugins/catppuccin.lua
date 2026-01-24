return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "latte",
      dark = "macchiato",
    },
    transparent_background = vim.fn.has("gui_running") == 0,
    custom_highlights = function(colors)
      return {
        LineNr = { fg = colors.overlay0 },
        TreesitterContext = { link = "Visual" },
        TreesitterContextBottom = { style = {} },
      }
    end,
    styles = {
      keywords = { "bold" },
    },
  },
}
