local helpers = require("personal.luasnip-helper-funcs")
local get_visual = helpers.get_visual
local in_mathzone = helpers.in_mathzone

return {
  -- LEFT/RIGHT ANGLE BRACKETS
  s(
    {
      trig = "a",
      desc = "Paired angle brackets",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\langle <> \rangle]], {
      d(1, get_visual),
    })
  ),
  -- LEFT/RIGHT BRACES
  s(
    {
      trig = "b",
      desc = "Paired braces",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\left\{ <> \right\}]], {
      d(1, get_visual),
    })
  ),
  -- LEFT/RIGHT PARENTHESES
  s(
    {
      trig = "p",
      desc = "Paired parentheses",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\left( <> \right)]], {
      d(1, get_visual),
    })
  ),
  -- LEFT/RIGHT BRACKETS
  s(
    {
      trig = "r",
      desc = "Paired brackets",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([=[\left[ <> \right]]=], {
      d(1, get_visual),
    })
  ),
  -- ESCAPED BRACES
  s(
    {
      trig = [[\{]],
      snippetType = "autosnippet",
      desc = "Paired braces",
    },
    fmta([[\{<>\}]], {
      d(1, get_visual),
    })
  ),
  -- LATEX QUOTES
  s(
    {
      trig = "``",
      snippetType = "autosnippet",
      desc = "Correct quotes",
    },
    fmta("``<>''", {
      d(1, get_visual),
    })
  ),
}
