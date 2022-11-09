ghtm_top_bar -save
gnotes " # $vars(g:pagename)"
ghtm_newnote

# severity
# {{{
proc severity {} {
  upvar row row
  upvar celltxt celltxt

  set seve [lvars $row severity]
  if {$seve eq "S1"} {
    set celltxt "<td gname=$row colname=severity contenteditable=\"true\" bgcolor=pink>$seve</td>"
  } else {
    set celltxt "<td gname=$row colname=severity contenteditable=\"true\" bgcolor=>$seve</td>"
  }
}
# }}}
ghtm_panel_begin
  ghtm_set_value filter_status All
  ghtm_set_value filter_status open
ghtm_panel_end

#-------------------------
# Filter
#-------------------------
set filter_status [lvars . filter_status]

set dirs [glob -type d *]
set rows ""
if {$filter_status eq "All"} {
  set rows $dirs
} else {
  foreach dir $dirs {
    set status [lvars $dir status]
    if {$status eq "open"} {
      lappend rows $dir
    }
  }
}
set ::ltblrows $rows

set     cols ""
lappend cols "proc:bton_delete;D"
#lappend cols "proc:ltbl_iname g:iname;Date"
lappend cols "proc:ltbl_linkurl url;Link"
lappend cols "proc:severity;Svrty"
lappend cols "edtable:status;status"
lappend cols "edtable:title;Title"
lappend cols "edtable:fmdate;fmdate"
lappend cols "edtable:todate;todate"
lappend cols "edtable:fmwho;fmwho"
lappend cols "edtable:towho;towho"
lappend cols "edtable:keywords;Keywords"
local_table tbl -c $cols -serial -dataTables

# vim:fdm=marker
