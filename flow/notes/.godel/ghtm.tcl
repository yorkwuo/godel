ghtm_top_bar -save

gnotes "
# $vars(g:pagename)
"
gexe_button newnote.tcl -nowin -name "newnote"
ghtm_onoff coldel -name Del
ghtm_onoff search -name Search
ghtm_onoff path -name Path

if {[lvars . path] eq "1"} {
  puts $fout <p>[pwd]</p>
}


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

if [file exist cols.tcl] {
  source cols.tcl
} else {
  lappend cols "edtable:class;Class"
  lappend cols "edtable:g:pagename;Title"
  lappend cols "edtable:g:keywords;Keywords"
}

if {[lvars . coldel] eq "1"} {
  lappend cols "proc:bton_delete;D"
}

if {[lvars . search] eq "1"} {
  local_table tbl -c $cols -serial -sortby "g:iname;d" -dataTables
} else {
  local_table tbl -c $cols -serial -sortby "g:iname;d"
}

# vim:fdm=marker
