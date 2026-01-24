local helpers = require("personal.luasnip-helper-funcs")
local get_visual = helpers.get_visual
local line_begin = conds.line_begin

return {
  -- SECTION
  s(
    {
      trig = "h1",
      snippetType = "autosnippet",
      desc = "Section",
      condition = line_begin,
    },
    fmta([[\section{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SUBSECTION
  s(
    {
      trig = "h2",
      snippetType = "autosnippet",
      desc = "Subsection",
      condition = line_begin,
    },
    fmta([[\subsection{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SUBSUBSECTION
  s(
    {
      trig = "h3",
      snippetType = "autosnippet",
      desc = "Subsubsection",
      condition = line_begin,
    },
    fmta([[\subsubsection{<>}]], {
      d(1, get_visual),
    })
  ),
  -- PARAGRAPH
  s(
    {
      trig = "pp",
      snippetType = "autosnippet",
      desc = "Paragraph",
      condition = line_begin,
    },
    fmta([[\paragraph{<>}]], {
      d(1, get_visual),
    })
  ),
}
