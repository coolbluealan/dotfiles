return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")
    conform.formatters.shfmt = {
      prepend_args = { "--indent", 2, "--case-indent", "--simplify" },
    }
    conform.formatters.sqlfluff = {
      exit_codes = { 0, 1 },
    }

    conform.setup({
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        cs = { "clang-format" },
        css = { "prettier" },
        fish = { "fish_indent" },
        haskell = { "ormolu" },
        html = { "prettier" },
        htmldjango = { "djlint" },
        javascript = { "prettier", "eslint_d" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "ruff_fix", "ruff_format" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        sql = { "sqlfluff" },
        tex = { "latexindent" },
        typescript = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
        yaml = { "prettier" },
        ["*"] = { "trim_newlines", "trim_whitespace" },
      },

      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 1000,
      },
    })
  end,
}
