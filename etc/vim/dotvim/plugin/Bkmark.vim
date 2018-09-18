" Author: York Wu (yorkwuo@gmail.com)
" Version: v0.1 2012/6/14
" Description: 
"   If you bookmark your text file with `@>' for chapter and `@=' for section,
"   the `:Bkmark' command in Vim can extract bookmark information and display
"   them at left hand side split window for you. You can jump to any specific position by
"   double-click the bookmark.
" Usage:
"   Chapter : @>
"   Section : @=
"   :Bkmark

command! Bkmark call <SID>Bkmark_Toggle_Window()

let Bkmark_title = "__Bkmark_List__"
" Bkmark_Toggle_Window
" {{{
" Extract the bookmark information from current buffer.
" Create the bookmark window if not yet create.
" Map the mouse click for tag jumpping.
func! s:Bkmark_Toggle_Window()
  " Disable the MiniBufExplorer if exists
  if exists(':CMiniBufExplorer')
    CMiniBufExplorer
  endif

  " If taglist window is open then close it.
  let winnum = bufwinnr(g:Bkmark_title)
  if winnum != -1
    call s:Bkmark_Close_Window()
    return
  endif

  " Create the bookmark window
  exe 'silent! topleft vertical 30 split' . g:Bkmark_title
  wincmd w

  " Extract bookmarks and store them in the List `bookmarks'
  let bookmarks = []
  let line_index = 1
  while line_index <= line("$")
    let line = getline(line_index)
    " Chapter
    if line =~ '@>'
      let m1 = matchlist(line, '@>\(.*\)$')
      let k = line_index . ":" . m1[1]
      call add(bookmarks, k)
    endif
    " Section
    if line =~ '@='
      let m2 = matchlist(line, '@=\(.*\)$')
      let k = "    " . line_index . ":" . m2[1]
      call add(bookmarks, k)
    endif

    let line_index += 1
  endwhile

  " Jump to bookmark window
  wincmd w
  silent! setlocal buftype=nofile
  silent! setlocal noswapfile
  silent! setlocal bufhidden=delete
  silent! setlocal nobuflisted
  silent! setlocal modifiable

  " Insert bookmarks to bookmark window
  let index = 1
  for bookmark in bookmarks
    call setline(index,bookmark)
    let index += 1
  endfor

  " Make bookmark window un-modifiable
  silent! setlocal nomodifiable

  nnoremap <buffer> <silent> p
                  \ :call <SID>Bkmark_Jump_To_Tag('preview')<CR>
  nnoremap <buffer> <silent> <2-LeftMouse>
                  \ :call <SID>Bkmark_Jump_To_Tag('go')<CR>
endfun
" }}}
" Bkmark_Jump_To_Tag
" {{{
func! s:Bkmark_Jump_To_Tag(win_ctrl)
  let a = getline(".")
  let m = matchlist(a, '\(\d\+\):')
  let line2go = m[1]
  wincmd w
  call cursor(line2go,0)
endfunc
" }}}
" Bkmark_Close_Window()
" {{{
function! s:Bkmark_Close_Window()
  let winnum = bufwinnr(g:Bkmark_title)

  if winnr() == winnum
    " Already in the taglist window. Close it and return
    if winbufnr(2) != -1
      " If a window other than the taglist window is open,
      " then only close the taglist window.
      close
    endif
  else
    " Goto the taglist window, close it and then come back to the
    " original window
    let curbufnr = bufnr('%')
    exe winnum . 'wincmd w'
    close
    " Need to jump back to the original window only if we are not
    " already in that window
    let winnum = bufwinnr(curbufnr)
    if winnr() != winnum
      exe winnum . 'wincmd w'
    endif
  endif
endfunction
" }}}
" vim:fdm=marker
