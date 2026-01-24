return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = function()
    vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
    vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")
    vim.keymap.set("n", "]b", "<Cmd>BufferLineMoveNext<CR>")
    vim.keymap.set("n", "[b", "<Cmd>BufferLineMovePrev<CR>")

    return {
      highlights = require("catppuccin.special.bufferline").get_theme(),
      options = {
        indicator = {
          style = "underline",
        },
      },
    }
  end,
}
