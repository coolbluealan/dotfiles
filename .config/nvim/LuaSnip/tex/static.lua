local helpers = require("personal.luasnip-helper-funcs")
local in_mathzone = helpers.in_mathzone
local in_text = helpers.in_text

return {
  -- ANGLE
  s(
    {
      trig = "(%A)gg",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      desc = [[\angle]],
      condition = in_mathzone,
    },
    fmta([[<>\angle ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  -- DOTS
  s({
    trig = "..",
    snippetType = "autosnippet",
    desc = [[\dots]],
  }, {
    t([[\dots]]),
  }),
  -- EQUIV
  s({
    trig = "==",
    snippetType = "autosnippet",
    desc = [[\equiv]],
    condition = in_mathzone,
  }, {
    t([[\equiv ]]),
  }),
  -- IMPLIES
  s({
    trig = ">>",
    snippetType = "autosnippet",
    desc = [[\implies]],
  }, {
    t([[\implies ]]),
  }),
  -- INTEGRAL FROM INFINITIES
  s({
    trig = "iii",
    snippetType = "autosnippet",
    desc = [[\int_{-\infty}^\infty]],
    condition = in_mathzone,
  }, {
    t([[\int_{-\infty}^\infty ]]),
  }),
  -- CDOT
  s({
    trig = "sd",
    snippetType = "autosnippet",
    desc = [[\cdot]],
    condition = in_mathzone,
  }, {
    t([[\cdot ]]),
  }),
  -- PARALLEL
  s({
    trig = "||",
    snippetType = "autosnippet",
    desc = [[\parallel]],
    condition = in_mathzone,
  }, {
    t([[\parallel ]]),
  }),
  -- TIMES
  s({
    trig = "xx",
    snippetType = "autosnippet",
    desc = [[\times]],
    condition = in_mathzone,
  }, {
    t([[\times ]]),
  }),
  -- TRIANGLE
  s({
    trig = "tt",
    snippetType = "autosnippet",
    desc = [[\triangle]],
    condition = in_mathzone,
  }, {
    t([[\triangle ]]),
  }),
}
