proc ghtm_href {name href} {
  upvar fout fout

  if [regexp -nocase {\.htm} $href] {
     puts $fout "<a href=$href>$name</a><br>"
  } elseif [regexp -nocase {\.htm} $href] {
  } else {
     puts $fout "<a href=$href type=text/txt>$name</a><br>"
  }

}
