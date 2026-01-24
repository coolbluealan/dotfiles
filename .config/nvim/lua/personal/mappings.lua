-- Mappings for faster split window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Easier paste
vim.keymap.set("n", "<C-p>", '"0p')
vim.keymap.set("n", "<C-M-p>", '"0P')

-- Folds
vim.keymap.set("n", "<Leader>a", "za")

-- Uppercase previous word
vim.keymap.set("i", "<M-u>", "<Esc>viwgUea")

-- Stop search highlighting
vim.keymap.set("n", "<Leader>n", "<Cmd>nohlsearch<CR>")

-- Save buffer
vim.keymap.set("n", "<CR>", "<Cmd>update<CR>")
vim.keymap.set("n", "<C-Enter>", "<Cmd>noautocmd update<CR>")

-- Delete buffer
vim.keymap.set("n", "<Leader>d", "<Cmd>bd<CR>")

-- Terminal Emulator
vim.keymap.set("n", "<Leader>e", "<Cmd>silent !alacritty --working-directory %:h &<CR>")
