ghtm_top_bar -save -new

gnotes " # $vars(g:pagename) "

# hiername
# {{{
proc hiername {} {
  upvar row row
  upvar celltxt celltxt

  set level [lvars $row level]
  set name  [lvars $row fullname]


  if {$level eq "2"} {
    set indent "<span style=margin-left:30px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } elseif {$level eq "3"} {
    set indent "<span style=margin-left:60px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } elseif {$level eq "4"} {
    set indent "<span style=margin-left:90px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } elseif {$level eq "5"} {
    set indent "<span style=margin-left:120px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } elseif {$level eq "6"} {
    set indent "<span style=margin-left:150px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } else {
    set indent ""
    set celltxt "<td bgcolor=lightyellow style=\"white-space:pre\">$name</td>"
  }
}
# }}}

ghtm_onoff adding -name adding

batch_onoff col_sdate   -name sdate
batch_onoff col_iname   -name iname
batch_onoff colrptto    -name rptto
batch_onoff colD        -name D
batch_onoff colLink     -name Link
batch_onoff colrole     -name role
batch_onoff colfullname -name fullname
batch_onoff colwhere    -name where
batch_onoff colKeywords -name Keywords
batch_onoff colorg      -name org
batch_onoff colid       -name id
batch_onoff colTitle    -name Title
batch_onoff colname     -name name
batch_onoff collevel    -name level
batch_onoff colhiername -name hiername
batch_onoff colnotes    -name notes

set     cols ""
cols_onoff "col_sdate   ; ed:sdate;sdate"
cols_onoff "col_iname   ; proc:ltbl_iname g:iname ; iname"
cols_onoff "colD        ; proc:bton_delete      ; D"
cols_onoff "colLink     ; proc:ltbl_linkurl url ; Link"
cols_onoff "colrptto    ; edtable:rptto         ; rptto"
cols_onoff "colid       ; edtable:id            ; id"
cols_onoff "colfullname ; edtable:fullname      ; fullname"
cols_onoff "colwhere    ; edtable:where         ; where"
cols_onoff "colKeywords ; edtable:keywords      ; Keywords"
cols_onoff "colorg      ; edtable:org           ; Org"
cols_onoff "colTitle    ; edtable:g:title       ; Title"
cols_onoff "colname     ; edtable:name          ; name"
cols_onoff "collevel    ; edtable:level         ; L"
cols_onoff "colhiername ; proc:hiername         ; hiername"
cols_onoff "colrole     ; edtable:role          ; role"
cols_onoff "colnotes    ; edtable:notes         ; notes"

if {[lvars . adding] eq "1"} {
  local_table tbl -c $cols -serial -sortby g:iname -sortopt {-decreasing}
} else {
  local_table tbl -c $cols -serial -f list.f
}

# vim:fdm=marker
