ghtm_top_bar -save -new
gnotes " # $vars(g:pagename)"
gexe_button new.tcl -cmd -name new
ghtm_onoff coldelete   -name D
ghtm_onoff collink     -name link
ghtm_onoff colseverity -name severity
ghtm_onoff colstatus   -name status
ghtm_onoff colfmdate   -name fmdate
ghtm_onoff colfmwho    -name fmwho
ghtm_onoff coltowho    -name towho
ghtm_onoff colkeywords -name keywords
ghtm_onoff colid       -name id
ghtm_onoff coltitle    -name title
ghtm_onoff coltodate   -name todate

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

set dirs [glob -nocomplain -type d *]
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
cols_onoff "coldelete  ; proc:bton_delete      ; D"
cols_onoff "collink    ; proc:ltbl_linkurl url ; Link"
cols_onoff "colseverity ; proc:severity         ; Svrty"
cols_onoff "colstatus   ; edtable:status        ; status"
cols_onoff "colfmdate   ; edtable:fmdate        ; fmdate"
cols_onoff "colfmwho    ; edtable:fmwho         ; fmwho"
cols_onoff "coltowho    ; edtable:towho         ; towho"
cols_onoff "colkeywords ; edtable:keywords      ; Keywords"
cols_onoff "colid       ; edtable:id            ; id"
cols_onoff "coltitle    ; edtable:title         ; Title"
cols_onoff "coltodate   ; edtable:todate        ; todate"
local_table tbl -c $cols -serial -dataTables

# vim:fdm=marker
