local helpers = require("personal.luasnip-helper-funcs")
local get_visual = helpers.get_visual
local in_mathzone = helpers.in_mathzone

return {
  s(
    {
      trig = "em",
      desc = [[Italics with \emph]],
    },
    fmta([[\emph{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "bo",
      desc = [[Bold with \textbf]],
    },
    fmta([[\textbf{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "tt",
      desc = [[Typewriter with \texttt]],
    },
    fmta([[\texttt{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "mt",
      desc = "Upright text in math environments",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\text{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "mr",
      desc = "Upright math in math environments",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\mathrm{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "mc",
      desc = "Math calligraphy in math environments",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\mathcal{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "mb",
      desc = "Blackboard math in math environments",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\mathbb{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    {
      trig = "mf",
      desc = "Boldface math in math environments",
      condition = in_mathzone,
      show_condition = in_mathzone,
    },
    fmta([[\mathbf{<>}]], {
      d(1, get_visual),
    })
  ),
}
