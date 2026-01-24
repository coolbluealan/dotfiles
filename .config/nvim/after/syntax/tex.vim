" Symbols
syntax match texMathSymbol "\\eps\>" contained conceal cchar=ε
syntax match texMathSymbol "\\dang\>" contained conceal cchar=∡
syntax match texMathSymbol "\\dg\>" contained conceal cchar=°

" Blackboard letters
syntax match texMathSymbol "\\CC\>" contained conceal cchar=ℂ
syntax match texMathSymbol "\\FF\>" contained conceal cchar=𝔽
syntax match texMathSymbol "\\NN\>" contained conceal cchar=ℕ
syntax match texMathSymbol "\\QQ\>" contained conceal cchar=ℚ
syntax match texMathSymbol "\\RR\>" contained conceal cchar=ℝ
syntax match texMathSymbol "\\ZZ\>" contained conceal cchar=ℤ

highlight! link Conceal String
