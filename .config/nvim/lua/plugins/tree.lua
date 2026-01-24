return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    vim.keymap.set("n", "<Leader>t", "<Cmd>NvimTreeToggle<CR>")

    return {
      filters = {
        custom = {
          "^.*\\.pdf$",
          "^.*\\.jpg$",
          "^.*\\.png$",
          "^__pycache__$",
          "^.*\\.aux$",
          "^.*\\.fdb_latexmk$",
          "^.*\\.fls$",
          "^.*\\.log$",
          "^.*\\.nav$",
          "^.*\\.out$",
          "^.*\\.pre$",
          "^.*\\.pytxcode$",
          "^.*\\.pytxmcr$",
          "^.*\\.pytxpyg$",
          "^.*\\.snm$",
          "^.*\\.synctex\\.gz$",
          "^.*\\.synctex\\(busy\\)$",
          "^.*\\.toc$",
          "^pythontex_data\\.pkl$",
        },
      },
    }
  end,
}
