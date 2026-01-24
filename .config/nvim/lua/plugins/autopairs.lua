return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({ ignored_next_char = [=[[%w%%%'%[%"%`]]=] })

    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    local brace_rule = vim.deepcopy(npairs.get_rules("{")[1])
    brace_rule.filetypes = { "tex" }
    npairs.get_rules("{")[1].not_filetypes = { "tex" }

    npairs.add_rules({
      Rule("$", "$", "tex"):with_pair(cond.none()),
      brace_rule:with_pair(cond.not_before_text("\\")),
    })
    table.insert(npairs.get_rules("'")[1].not_filetypes, "tex")
    table.insert(npairs.get_rules('"')[1].not_filetypes, "tex")
    npairs.get_rules("`")[1].not_filetypes = { "tex" }
  end,
}
