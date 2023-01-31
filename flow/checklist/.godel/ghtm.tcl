ghtm_top_bar -save -filter 1

gnotes "#$vars(g:pagename)"


ghtm_panel_begin
  gexe_button newnote.tcl -nowin -name "new"
  ghtm_onoff coldel  -name Del
  ghtm_onoff coltick -name Tick

ghtm_panel_end

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

set cols ""
cols_onoff "coldel      ; proc:bton_delete   ; D"
cols_onoff "coltick     ; proc:bton_tick     ; T"
lappend cols "edtable:class      ; Class"
lappend cols "edtable:title      ; Title"
lappend cols "edtable:g:keywords ; Keywords"

#local_table tbl -c $cols -serial -sortby "g:iname" -dataTables
local_table tbl -c $cols -serial -sortby "class"

# vim:fdm=marker
