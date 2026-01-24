local helpers = require("personal.luasnip-helper-funcs")
local get_visual = helpers.get_visual
local line_begin = conds.line_begin

return {
  -- FAST I/O
  s({
    trig = "fastio",
    snippetType = "autosnippet",
    desc = "Fast I/O",
    condition = line_begin,
  }, {
    t({
      "ios::sync_with_stdio(false);",
      "cin.tie(nullptr);",
      "",
    }),
  }),
  -- FILE I/O
  s(
    {
      trig = "fileio",
      snippetType = "autosnippet",
      desc = "File I/O",
      condition = line_begin,
    },
    fmt(
      [[
      freopen("{}.in", "r", stdin);
      freopen("{}.out", "w", stdout);

      ]],
      { d(1, get_visual), rep(1) }
    )
  ),
  -- POLICY BASED DATA STRUCTURE
  s({
    trig = "pbds",
    snippetType = "autosnippet",
    desc = "Policy based data structures",
    condition = line_begin,
  }, {
    t({
      "#include <ext/pb_ds/assoc_container.hpp>",
      "#include <ext/pb_ds/tree_policy.hpp>",
      "using namespace __gnu_pbds;",
      "",
    }),
  }),
}
