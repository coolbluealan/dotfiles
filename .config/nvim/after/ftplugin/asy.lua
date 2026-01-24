-- asy compile and open viewer
vim.keymap.set("n", "<Leader>v", "<Cmd>update<CR><Cmd>silent !asy -V -f pdf % &<CR>", { buffer = true })
-- asy compile
vim.keymap.set("n", "<CR>", "<Cmd>update<CR><Cmd>silent !asy -f pdf % &<CR>", { buffer = true })
-- asy compile verbose (show errors)
vim.keymap.set("n", "<Leader>c", "<Cmd>update<CR><Cmd>!asy -f pdf %<CR>", { buffer = true })
