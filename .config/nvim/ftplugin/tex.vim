" VIMTEX CONFIGURATION

" Options

let g:vimtex_syntax_conceal = {
  \ 'accents': 1,
  \ 'ligatures': 1,
  \ 'cites': 1,
  \ 'fancy': 0,
  \ 'greek': 1,
  \ 'math_bounds': 0,
  \ 'math_delimiters': 1,
  \ 'math_fracs': 0,
  \ 'math_super_sub': 0,
  \ 'math_symbols': 1,
  \ 'sections': 0,
  \ 'spacing': 0,
  \ 'styles': 1,
  \ }

let g:vimtex_syntax_custom_envs = [
  \ {
  \   'name': 'asy',
  \   'region': 'texCodeZone',
  \   'nested': 'asy'
  \ },
  \ {
  \   'name': 'asydef',
  \   'region': 'texCodeZone',
  \   'nested': 'asy'
  \ },
  \ ]

let g:vimtex_quickfix_ignore_filters = [
  \ 'Underfull \\hbox',
  \ 'Overfull \\hbox',
  \ 'LaTeX Warning: .\+ float specifier changed to',
  \ ]

let g:vimtex_env_toggle_math_map = {
  \ '$': '\[',
  \ '\[': 'align*',
  \ '$$': '\[',
  \ '\(': '$',
  \ }

let g:vimtex_indent_enabled = 0
let g:vimtex_imaps_enabled = 0
let g:vimtex_fold_enabled = 1

" Mappings

nmap <buffer> csm <Plug>(vimtex-env-change-math)
nmap <buffer> dsm <Plug>(vimtex-env-delete-math)
nmap <buffer> tsm <Plug>(vimtex-env-toggle-math)

omap <buffer> im <Plug>(vimtex-i$)
xmap <buffer> im <Plug>(vimtex-i$)
omap <buffer> am <Plug>(vimtex-a$)
xmap <buffer> am <Plug>(vimtex-a$)

omap <buffer> ii <Plug>(vimtex-im)
xmap <buffer> ii <Plug>(vimtex-im)
omap <buffer> ai <Plug>(vimtex-am)
xmap <buffer> ai <Plug>(vimtex-am)

" GENERAL LATEX SETTINGS

" Zathura

let g:vimtex_view_method = "zathura"
nnoremap <buffer> <Leader>v <Cmd>VimtexView<CR>

" Compilation
if stridx(expand('%:p'), 'dotdb') != -1 || stridx(expand('%:t'), 'dot.tex') != -1
  let b:vimtex_main = '/tmp/preview_' . $USER . '/dot_preview.tex'
endif

nnoremap <buffer> <Leader>c <Cmd>update<CR><Cmd>VimtexCompile<CR>
