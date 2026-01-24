local helpers = require("personal.luasnip-helper-funcs")
local get_visual = helpers.get_visual
local in_text = helpers.in_text
local line_begin = conds.line_begin

return {
  -- INLINE MATH
  s(
    {
      trig = "mm",
      snippetType = "autosnippet",
      desc = "Inline math",
      condition = in_text,
    },
    fmta("$<>$", {
      d(1, get_visual),
    })
  ),
  -- DISPLAY MATH
  s(
    {
      trig = "m",
      desc = "Display math",
      condition = in_text,
      show_condition = in_text,
    },
    fmta(
      [[
      \[ <> \]
      ]],
      { d(1, get_visual) }
    )
  ),
  -- GENERIC ENVIRONMENT
  s(
    {
      trig = "new",
      snippetType = "autosnippet",
      desc = "Environment",
      condition = line_begin,
    },
    fmta(
      [[
        \begin{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    )
  ),
  -- TWO ARG ENVIRONMENT
  s(
    {
      trig = "n2",
      snippetType = "autosnippet",
      desc = "Two arg environment",
      condition = line_begin,
    },
    fmta(
      [[
        \begin{<>}{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        rep(1),
      }
    )
  ),
}
