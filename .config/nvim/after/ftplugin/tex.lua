require("cmp").setup.buffer({
  sources = {
    { name = "path" },
    { name = "luasnip" },
    { name = "vimtex" },
    { name = "buffer" },
  },
})

vim.opt_local.conceallevel = 2
vim.opt_local.fillchars = "fold: "
