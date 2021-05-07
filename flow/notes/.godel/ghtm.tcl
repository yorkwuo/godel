ghtm_top_bar -save -filter 1

gexe_button newnote.tcl -nowin -name "newnote"

# delete_button
# {{{
proc delete_button {} {
  upvar celltxt celltxt
  upvar row     row

  if [file exist $row/.delete.gtcl] {
  } else {
    set kout [open $row/.delete.gtcl w]
      puts $kout "set pagepath \[file dirname \[file dirname \[info script]]]"
      puts $kout "cd \$pagepath"
      puts $kout "exec rm -rf $row"
      puts $kout "exec godel_draw.tcl"
      puts $kout "exec xdotool search --name \"notes — Mozilla Firefox\" key ctrl+r"
    close $kout
  }

  if [file exist "$row/.delete.gtcl"] {
    set celltxt "<td><a href=$row/.delete.gtcl class=\"w3-btn w3-teal w3-round\" type=text/gtcl>D</a></td>"
  } else {
    set celltxt "<td></td>"
  }
}
# }}}
# check_button
# {{{
proc check_button {} {
  upvar celltxt celltxt
  upvar row     row

  if [file exist $row/.check.gtcl] {
  } else {
    set kout [open $row/.check.gtcl w]
      puts $kout "set pagepath \[file dirname \[file dirname \[info script]]]"
      puts $kout "cd \$pagepath"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set check_status \[lvars $row check_status]"
      puts $kout "if {\$check_status eq \"\" | \$check_status eq \"1\"} {"
      puts $kout "  lsetvar $row check_status 0"
      puts $kout "} else {"
      puts $kout "  lsetvar $row check_status 1"
      puts $kout "}"
      puts $kout "exec godel_draw.tcl"
      puts $kout "exec xdotool search --name \"notes — Mozilla Firefox\" key ctrl+r"
    close $kout
  }

  if [file exist "$row/.check.gtcl"] {
    set celltxt "<td><a href=$row/.check.gtcl class=\"w3-btn w3-teal w3-round\" type=text/gtcl>Chk</a></td>"
  } else {
    set celltxt "<td></td>"
  }
}
# }}}
proc dname {} {
  upvar celltxt celltxt
  upvar row     row

  set check_status [lvars $row check_status]
  if {$check_status eq "NA"} {
    set check_status 0
  }
  if {$check_status} {
    set celltxt "<td bgcolor=palegreen><a href=$row/.index.htm>$row</a></td>"
  } else {
    set celltxt "<td><a href=$row/.index.htm>$row</a></td>"
  }
}


lappend cols "proc:delete_button;Del"
lappend cols "proc:check_button;Chk"
#lappend cols "g:pagename;DirName"
lappend cols "proc:dname;Dirname"
lappend cols "edtable:title;Title"
lappend cols "edtable:g:keywords;Keywords"
local_table tbl -c $cols

# vim:fdm=marker
