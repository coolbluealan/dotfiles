syn match ysaEscapeLine "^!.*"
syn region ysaComment start="#" end="$" contains=@Spell
syn match ysaSemi " ; \| ;$"

syn keyword ysaFunction circumcenter incenter excenter orthocenter centroid
syn keyword ysaFunction circumcircle incircle excircle circle CR conic arc arccircle
syn keyword ysaFunction dir foot extension abs conj unit reflect rotate
syn keyword ysaFunction markrightangle markangle IP midpoint intersect bisectorpoint
syn keyword ysaBuiltin origin unitcircle cycle

syn match ysaNumber "[0-9.]\+"
syn match ysaOperator "=\|+\|-\|*\|\/\|--\|^^\|\.\." containedin=ysaDefineHeader

syn match ysaDefineHeader "\v^([[:alnum:]_&']+)( [\-0-9A-Z.]+)? [.:;]?\= " keepend contains=ysaRotate
syn match ysaRotate "\( [\-0-9A-Z.]\+\)" contained

syn match ysaPen "\v(pale|light|medium|heavy|deep|dark)?(red|green|blue|cyan|yellow|gray|grey|magenta|olive|brown)" contains=@NoSpell
syn keyword ysaPen black white orange fuchsia chartreuse springgreen purple royalblue pink
syn keyword ysaPen solid dashed dotted longdashed dashdotted longdashdotted

hi def link ysaBuiltin Structure
hi def link ysaComment Comment
hi def link ysaDefineHeader Identifier
hi def link ysaEscapeLine String
hi def link ysaFunction Keyword
hi def link ysaNumber Number
hi def link ysaOperator Operator
hi def link ysaPen Constant
hi def link ysaRotate Label
hi def link ysaSemi Delimiter
