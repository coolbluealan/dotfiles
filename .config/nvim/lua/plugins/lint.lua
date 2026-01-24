return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        lint.try_lint()
        lint.try_lint("codespell")
      end,
    })

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      rust = { "clippy" },
      sql = { "sqlfluff" },
      tex = { "chktex" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }
  end,
}
