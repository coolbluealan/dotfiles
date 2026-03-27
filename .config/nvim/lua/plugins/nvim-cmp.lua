return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
    "windwp/nvim-autopairs",
  },
  event = "InsertEnter",
  opts = function()
    local cmp = require("cmp")
    local ls = require("luasnip")

    cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "buffer" },
      }),
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
        { name = "buffer" },
      }),
    })

    return {
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = require("lspkind").cmp_format({
          maxwidth = {
            abbr = 50,
            menu = 30,
          },
          ellipsis_char = "...",
          show_labelDetails = true,
          menu = {
            buffer = "[Buf]",
            luasnip = "[Snip]",
            nvim_lsp = "[LSP]",
          },
        }),
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          elseif ls.expandable() then
            ls.expand()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-e>"] = cmp.mapping.abort(),
      },
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      -- Order here determines order in cmp menu
      sources = {
        { name = "path" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "buffer" },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    }
  end,
}
