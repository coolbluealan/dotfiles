return {
  "numToStr/Comment.nvim",
  opts = function()
    local ft = require("Comment.ft")

    ft.asy = "//%s"
    ft.tex = "%%%s"
    ft.tsqx = "#%s"
    ft.ysa = "#%s"

    return { ---LHS of toggle mappings in NORMAL + VISUAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gll",
        ---Block-comment toggle keymap
        block = "gcc",
      },

      ---LHS of operator-pending mappings in NORMAL + VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = "gl",
        ---Block-comment keymap
        block = "gc",
      },

      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
      },
    }
  end,
}
