syn match tsqEscapeLine "!.*"
syn region tsqComment start="#" end="$" contains=@Spell
syn match tsqSlash " / \| /$"

syn match tsqSpecial "\~\(triangle\|regular\)"
syn keyword tsqFunction circumcenter incenter excenter orthocenter centroid
syn keyword tsqFunction circumcircle incircle excircle circle
syn keyword tsqFunction dir foot extension abs conj unit reflect rotate
syn keyword tsqFunction markrightangle markangle IP midpoint intersect bisectorpoint arc
syn keyword tsqBuiltin origin unitcircle
syn keyword tsqCycle cycle

syn match tsqNumber "[0-9.]\+"
syn match tsqOperator "=\|+\|-\|*\|\/\|--\|^^\|\.\." containedin=tsqDefineHeader

syn match tsqDefineHeader "\v^([[:alnum:]_&']+)( [0-9A-Z.]+)? [.:;]?\= " keepend contains=tsqRotate
syn match tsqRotate "\( [0-9A-Z.]\+\)" contained

syn match tsqPen "\v(pale|light|medium|heavy|deep|dark)?(red|green|blue|cyan|yellow|gray|grey|magenta|olive|brown)" contains=@NoSpell
syn keyword tsqPen black white orange fuchsia chartreuse springgreen purple royalblue pink
syn keyword tsqPen solid dashed dotted longdashed dashdotted longdashdotted

hi def link tsqBuiltin Constant
hi def link tsqComment Comment
hi def link tsqCycle PreProc
hi def link tsqDefineHeader Identifier
hi def link tsqEscapeLine String
hi def link tsqFunction Keyword
hi def link tsqNumber Number
hi def link tsqOperator Operator
hi def link tsqPen Constant
hi def link tsqRotate Character
hi def link tsqSlash NonText
hi def link tsqSpecial Special
