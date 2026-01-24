vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.clipboard = "unnamed"
vim.opt.colorcolumn = "+1"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.expandtab = true
vim.opt.foldcolumn = "1"
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"
vim.opt.formatoptions:remove({ "t" })
vim.opt.guifont = "Hack Nerd Font Mono:h13"
vim.opt.ignorecase = true
vim.opt.nrformats:append({ "alpha" })
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 1
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.textwidth = 80
vim.opt.timeoutlen = 300
vim.opt.winborder = "single"
vim.opt.wrap = false

require("personal/filetype")
require("personal/mappings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = { { import = "plugins" } },
  ui = { border = "single" },
  change_detection = { notify = false },
})

vim.cmd.colorscheme("catppuccin")
