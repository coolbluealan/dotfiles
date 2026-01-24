-- tsqx -> asy compile and open viewer
vim.keymap.set("n", "<Leader>v", "<Cmd>update<CR><Cmd>silent !tsqx -p -t % | asy -V - &<CR>", { buffer = true })
-- tsqx -> asy compile
vim.keymap.set("n", "<CR>", "<Cmd>update<CR><Cmd>silent !tsqx -p -t % | asy - &<CR>", { buffer = true })
-- tsqx -> asy compile verbose (show errors)
vim.keymap.set("n", "<Leader>c", "<Cmd>update<CR><Cmd>!tsqx -p -t % | asy -<CR>", { buffer = true })
-- tsqx -> asy copy
vim.keymap.set("n", "<Leader>p", "<Cmd>update<CR><Cmd>silent !tsqx % | xclip<CR>", { buffer = true })
