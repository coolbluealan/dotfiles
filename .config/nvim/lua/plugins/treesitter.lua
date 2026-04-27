return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "bash",
      "c",
      "c_sharp",
      "cpp",
      "css",
      "fish",
      "gdscript",
      "html",
      "htmldjango",
      "java",
      "javascript",
      "lua",
      "markdown",
      "python",
      "rust",
      "sql",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
      "zathurarc",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "*" },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
