-- ysa -> asy compile and open viewer
vim.keymap.set("n", "<Leader>v", "<Cmd>update<CR><Cmd>silent !ysa -p % | asy -V - &<CR>", { buffer = true })
-- ysa -> asy compile
vim.keymap.set("n", "<CR>", "<Cmd>update<CR><Cmd>silent !ysa -p % | asy - &<CR>", { buffer = true })
-- ysa -> asy compile verbose (show errors)
vim.keymap.set("n", "<Leader>c", "<Cmd>update<CR><Cmd>!ysa -p % | asy -<CR>", { buffer = true })
-- ysa -> asy copy
vim.keymap.set("n", "<Leader>p", "<Cmd>update<CR><Cmd>silent !ysa -y % | xclip<CR>", { buffer = true })
-- ysa -> asy copy with preamble
vim.keymap.set("n", "<Leader>P", "<Cmd>update<CR><Cmd>silent !ysa -p -y % | xclip<CR>", { buffer = true })
