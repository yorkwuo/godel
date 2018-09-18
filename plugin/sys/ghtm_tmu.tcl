proc ghtm_tmu {tag {content ""}} {
  upvar fout fout
  upvar txt txt
  if {$content == ""} {
    puts $fout [tmu $tag:0- "" $txt]
  } else {
    puts $fout [tmu $tag:0- "" $content]
  }
}

