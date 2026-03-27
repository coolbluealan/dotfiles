require("cmp").setup.buffer({
  sources = {
    { name = "jupynium" },
    { name = "path" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
})

vim.opt.textwidth = 88
