proc ghtm_h {htag title} {
  upvar fout fout
  upvar vars vars
  puts $fout "<$htag><span class=\"w3-tag w3-deep-purple\">$title</span></$htag>"
  regsub -all {\s} $title {_} id
  lappend vars(toc) [list $htag $title $id]
}
