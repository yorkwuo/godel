proc ghtm_paragraph {id} {
  upvar env env
  upvar fout fout

  set shortname $id

  set fname ".godel/$shortname.paragraph.txt"
  if ![file exist $fname] {
    set kout [open $fname w]
      puts $kout "<pre>"
      puts $kout "</pre>"
    close $kout
  }

  puts $fout "<div id=$id><span class=\"w3-tag\">$id<a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_paragraph.tcl] type=text/txt>(script)</a>\
  <a href=.godel/$shortname.paragraph.txt type=text/txt>edit</a></span></div>"

  #puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"

  set fin [open .godel/$shortname.paragraph.txt]
    while {[gets $fin line] >= 0} {
      puts $fout $line
    }
  close $fin

  #puts $fout "</div>"

}
