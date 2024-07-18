ghtm_top_bar -save -new -js
pathbar 1
puts $fout {
  <style>
     .myBox {
      width: 18px;
      height: 18px;
      background-color: white;
      display: flex;
      justify-content: center;
      align-items: center;
      color: white;
      cursor: pointer;
    }
    tr:hover {background-color:white;}

  </style>
}

proc ltbl_colorbox {type} {
  upvar row     row
  upvar celltxt celltxt

  set celltxt "<td><div class=myBox name=$type.$row></div></td>"
}

batch_onoff coldone     -name done
batch_onoff coldelete   -name D
batch_onoff colclass     -name class
batch_onoff collink     -name link
batch_onoff colseverity -name severity
batch_onoff colstatus   -name status
batch_onoff colfmdate   -name fmdate
batch_onoff colfmwho    -name fmwho
batch_onoff coltowho    -name towho
batch_onoff colkeywords -name keywords
batch_onoff colid       -name id
batch_onoff coltitle    -name title
batch_onoff colnotes    -name notes
batch_onoff coltodate   -name todate

linkbox done -gsize

set dirs [glob -nocomplain -type d *]
set classes ""
foreach dir $dirs {
  lappend classes [lvars $dir class]
}
set classes [lsort -unique $classes]

puts $fout "<br>"
ghtm_reset
foreach c $classes {
  if {$c eq ""} continue
  if {$c eq "NA"} continue
  ghtm_keyword_button tbl Class $c -key class
}



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
#lappend cols "proc:ltbl_iname g:iname;Name"
cols_onoff "coldone    ; proc:bton_move done done     ; move"
cols_onoff "coldelete  ; proc:bton_delete      ; D"
cols_onoff "collink    ; proc:ltbl_linkurl url ; Link"
cols_onoff "colseverity ; proc:severity         ; Svrty"
cols_onoff "colstatus   ; ed:status        ; status"
cols_onoff "colfmdate   ; ed:fmdate        ; fmdate"
cols_onoff "colfmwho    ; ed:fmwho         ; fmwho"
cols_onoff "coltowho    ; ed:towho         ; towho"
cols_onoff "colkeywords ; ed:keywords      ; Keywords"
cols_onoff "colid       ; ed:id            ; id"
cols_onoff "colclass   ; ed:class ; Class"
#cols_onoff "coltitle    ; proc:ltbl_cfd      ; H"
cols_onoff "coltitle    ; proc:ltbl_colorbox status ; C"
#cols_onoff "coltitle    ; ed:title    ; title"
cols_onoff "coltitle    ; ed:g:pagename    ; g:pagename"
cols_onoff "colnotes     ; ed:notes         ; Notes"
cols_onoff "coltodate   ; ed:todate        ; todate"
local_table tbl -c $cols -serial -dataTables -sortby class -sortopt "-increasing" -exclude {done}

# vim:fdm=marker
