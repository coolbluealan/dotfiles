return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  config = function()
    -- Mappings
    vim.cmd([[
      " Expand: Moved to cmp config
      " imap <silent><expr> <Tab> luasnip#expandable() ? '<Plug>luasnip-expand-snippet' : '<Tab>'
      " Jump forward
      imap <silent><expr> jk luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : 'jk'
      smap <silent><expr> jk luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : 'jk'
      " Jump backward
      imap <silent><expr> <C-b> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'
      smap <silent><expr> <C-b> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'
      " Cycle forward through choice nodes with Control-F
      imap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
      smap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
    ]])

    -- Reload snippets edited in another neovim instance
    vim.keymap.set(
      "n",
      "<Leader>L",
      '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})<CR>'
    )

    -- Snippet configuration

    require("luasnip").config.set_config({
      -- Faster performance
      history = false,
      -- Autotrigger snippets
      enable_autosnippets = true,
      -- Visual selection
      store_selection_keys = "<Tab>",
      -- Update nodes like rep()
      update_events = "TextChanged,TextChangedI",
      -- Check when exiting snippet region
      region_check_events = "InsertEnter",
      delete_check_events = "InsertLeave",
    })

    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip" })
  end,
}
