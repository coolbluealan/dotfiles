return {
  "nvim-treesitter/nvim-treesitter-context",
  opts = function()
    vim.keymap.set("n", "<C-T>", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end)
    return { max_lines = 3 }
  end,
}
