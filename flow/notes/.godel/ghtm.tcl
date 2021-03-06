ghtm_top_bar -save -filter 1

gexe_button newnote.tcl -nowin -name "newnote"

# dname
# {{{
proc dname {} {
  upvar celltxt celltxt
  upvar row     row

  set tick_status [lvars $row tick_status]
  if {$tick_status eq "NA"} {
    set tick_status 0
  }
  if {$tick_status} {
    set celltxt "<td bgcolor=palegreen><a href=$row/.index.htm>$row</a></td>"
  } else {
    set celltxt "<td><a href=$row/.index.htm>$row</a></td>"
  }
}
# }}}

lappend cols "proc:bton_delete notes;Del"
lappend cols "proc:bton_tick notes;Tick"
#lappend cols "g:pagename;DirName"
#lappend cols "proc:dname;Dirname"
lappend cols "edtable:title;Title"
lappend cols "edtable:g:keywords;Keywords"
local_table tbl -c $cols -serial -sortby "g:iname;d"

# vim:fdm=marker
