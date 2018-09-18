" Author: York Wu
" Email : yorkwuo@gmail.com
" Version: v0.1 2012/6/13
" Description: 
" FontZoom.vim is originated by OMI TAKU and he named the script as zoom.vim.
" I just fix some bugs to make it workable in Linux environment.
" Usage:
" + : Larger the font size
" - : Smaller the font size
" = : Restore to original font size

if &cp || exists("g:loaded_zoom")
    finish
endif
let g:loaded_zoom = 1

let s:save_cpo = &cpo
set cpo&vim

" keep default value
let s:current_font = &guifont

command! -narg=0 ZoomIn    :call s:ZoomIn()
command! -narg=0 ZoomOut   :call s:ZoomOut()
command! -narg=0 ZoomReset :call s:ZoomReset()

" map
nmap + :ZoomIn<CR>
nmap - :ZoomOut<CR>
nmap = :ZoomReset<CR>

" ZoomIn
fun! s:ZoomIn()
  let size = matchstr(&guifont, '\(\d\+\)')
  let size += 1
  let newfont = substitute(&guifont, '\d\+', size , "")
  echo newfont
  let &guifont = newfont
endfunc

" ZoomOut
fun! s:ZoomOut()
  let size = matchstr(&guifont, '\(\d\+\)')
  let size -= 1
  let newfont = substitute(&guifont, '\d\+', size , "")
  let &guifont = newfont
endfunc

" Reset guifont size
function! s:ZoomReset()
  let &guifont = s:current_font
endfunction


"guifont=Consolas:h16:cANSI:qDRAFT
