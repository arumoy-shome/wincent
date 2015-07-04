" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:loupe_loaded') || &compatible || v:version < 700
  finish
endif
let g:loupe_loaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

" Map <leader>n to clear search highlighting.
let s:map = exists('g:LoupeClearHighlightMap') ? g:LoupeClearHighlightMap : 1
if s:map
  if !hasmapto('<Plug>LoupeClearHighlight') && maparg('<leader>n', 'n') ==# ''
    silent! nmap <silent> <unique> <leader>n <Plug>LoupeClearHighlight
  endif
endif
nnoremap <silent> <Plug>LoupeClearHighlight
      \ :nohlsearch<CR>
      \ :call loupe#private#clear_highlight()<CR>

" When g:LoupeVeryMagic is true (and it is by default), make Vim's regexen more
" Perl-like.
function s:MagicString()
  let s:magic = exists('g:LoupeVeryMagic') ? g:LoupeVeryMagic : 1
  return s:magic ? '\v' : ''
endfunction

nnoremap <expr> / loupe#private#prepare_highlight('/' . <SID>MagicString())
nnoremap <expr> ? loupe#private#prepare_highlight('?' . <SID>MagicString())
xnoremap <expr> / loupe#private#prepare_highlight('/' . <SID>MagicString())
xnoremap <expr> ? loupe#private#prepare_highlight('?' . <SID>MagicString())
if !empty(s:MagicString())
  cnoremap <expr> / loupe#private#very_magic_slash()
endif

" When g:LoupeCenterResults is true (and it is by default), remain vertically
" centered when moving to next/previous search.
let s:center = exists('g:LoupeCenterResults') ? g:LoupeCenterResults : 1
let s:center_string = s:center ? 'zz' : ''

execute 'nnoremap <silent> # #' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> * *' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> N N' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> g# g#' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> g* g*' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> n n' . s:center_string . ':call loupe#private#hlmatch()<CR>'

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions