local helpers = require("personal.luasnip-helper-funcs")
local get_visual = helpers.get_visual
local in_mathzone = helpers.in_mathzone

return {
  -- SUPERSCRIPT
  s(
    {
      trig = "'",
      desc = "Superscript",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta("^{<>}", {
      d(1, get_visual),
    })
  ),
  -- SUBSCRIPT
  s(
    {
      trig = ";",
      desc = "Subscript",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta("_{<>}", {
      d(1, get_visual),
    })
  ),
  -- FRACTION
  s(
    {
      trig = "(%A)ff",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      desc = "Fraction",
      condition = in_mathzone,
    },
    fmta([[<>\frac{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
      i(2),
    })
  ),
  -- SQUARE ROOT
  s(
    {
      trig = "sr",
      desc = "Square root",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\sqrt{<>}]], {
      d(1, get_visual),
    })
  ),
  -- BINOMIAL
  s(
    {
      trig = "bn",
      desc = "Binomial",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\binom{<>}{<>}]], {
      d(1, get_visual),
      i(2),
    })
  ),
  -- SUM
  s(
    {
      trig = "su",
      desc = "Sum",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\sum_{<>}^{<>}]], {
      i(1),
      i(2),
    })
  ),
  -- PRODUCT
  s(
    {
      trig = "pr",
      desc = "Product",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\prod_{<>}^{<>}]], {
      i(1),
      i(2),
    })
  ),
  -- BOXED
  s(
    {
      trig = "bx",
      desc = "Boxed",
    },
    fmta([[\boxed{<>}]], {
      d(1, get_visual),
    })
  ),
  -- BOXED
  s(
    {
      trig = "v",
      desc = "Vocab",
    },
    fmta([[\vocab{<>}]], {
      d(1, get_visual),
    })
  ),
}
