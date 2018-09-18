proc ghtm_code_snip {type title id codes} {
  upvar fout fout
  set txt [tmu h5:0- "" $title]
  set codes [string trim $codes]
  append txt [tmu pre:0- "" [tmu code:0- "id=$id class=language-$type" $codes]]
  puts $fout $txt
}

