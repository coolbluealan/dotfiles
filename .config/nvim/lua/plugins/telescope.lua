return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    vim.keymap.set("n", "<Leader>/", "<Cmd>Telescope current_buffer_fuzzy_find theme=dropdown<CR>")
    vim.keymap.set("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>")
    vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files theme=dropdown<CR>")
    vim.keymap.set("n", "<Leader>fg", "<Cmd>Telescope live_grep<CR>")
    vim.keymap.set("n", "<Leader>fh", "<Cmd>Telescope help_tags theme=dropdown<CR>")
    vim.keymap.set("n", "<Leader>fo", "<Cmd>Telescope oldfiles theme=dropdown<CR>")
  end,
}
