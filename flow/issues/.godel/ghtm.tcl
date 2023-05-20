ghtm_top_bar -save -new
pathbar 1
puts $fout <br>
batch_onoff coldone     -name done
batch_onoff coldelete   -name D
batch_onoff collink     -name link
batch_onoff colseverity -name severity
batch_onoff colstatus   -name status
batch_onoff colfmdate   -name fmdate
batch_onoff colfmwho    -name fmwho
batch_onoff coltowho    -name towho
batch_onoff colkeywords -name keywords
batch_onoff colid       -name id
batch_onoff coltitle    -name title
batch_onoff coltodate   -name todate

linkbox done -gsize


# severity
# {{{
proc severity {} {
  upvar row row
  upvar celltxt celltxt

  set seve [lvars $row severity]
  if {$seve eq "NA"} {
    set seve ""
  }
  if {$seve eq "S1"} {
    set celltxt "<td gname=$row colname=severity contenteditable=\"true\" bgcolor=pink>$seve</td>"
  } else {
    set celltxt "<td gname=$row colname=severity contenteditable=\"true\" bgcolor=>$seve</td>"
  }
}
# }}}


set     cols ""
lappend cols "proc:ltbl_iname g:iname;Name"
cols_onoff "coldone    ; proc:bton_move done done     ; move"
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
local_table tbl -c $cols -serial -dataTables -sortby g:iname -sortopt "-decreasing" -exclude {done}

# vim:fdm=marker
