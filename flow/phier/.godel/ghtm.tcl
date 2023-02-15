ghtm_top_bar -save
gnotes " # $vars(g:pagename) "

# hiername
# {{{
proc hiername {} {
  upvar row row
  upvar celltxt celltxt

  set level [lvars $row level]
  set name  [lvars $row name]


  if {$level eq "2"} {
    set indent "<span style=margin-left:20px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } elseif {$level eq "3"} {
    set indent "<span style=margin-left:40px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } elseif {$level eq "4"} {
    set indent "<span style=margin-left:60px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } elseif {$level eq "5"} {
    set indent "<span style=margin-left:80px></span>"
    set celltxt "<td style=\"white-space:pre\">$indent$name</td>"
  } else {
    set indent ""
    set celltxt "<td bgcolor=lightyellow style=\"white-space:pre\">$name</td>"
  }
}
# }}}

ghtm_newnote
ghtm_onoff collevel    -name level
ghtm_onoff colrptto    -name rptto
ghtm_onoff colD        -name D
ghtm_onoff colLink     -name Link
ghtm_onoff colarea     -name area
ghtm_onoff colrole     -name role
ghtm_onoff colfullname -name fullname
ghtm_onoff colwhere    -name where
ghtm_onoff colKeywords -name Keywords
ghtm_onoff colorg      -name org
ghtm_onoff colid       -name id
ghtm_onoff colTitle    -name Title
ghtm_onoff colname     -name name
ghtm_onoff colhiername -name hiername
ghtm_onoff colnotes    -name notes

set     cols ""
cols_onoff "collevel    ; edtable:level         ; level"
cols_onoff "colrptto    ; edtable:rptto         ; rptto"
cols_onoff "colD        ; proc:bton_delete      ; D"
cols_onoff "colLink     ; proc:ltbl_linkurl url ; Link"
cols_onoff "colfullname ; edtable:fullname      ; fullname"
cols_onoff "colwhere    ; edtable:where         ; where"
cols_onoff "colKeywords ; edtable:keywords      ; Keywords"
cols_onoff "colorg      ; edtable:org           ; Org"
cols_onoff "colid       ; edtable:id            ; id"
cols_onoff "colTitle    ; edtable:g:title       ; Title"
cols_onoff "colname     ; edtable:name          ; name"
cols_onoff "colhiername ; proc:hiername         ; hiername"
cols_onoff "colarea     ; edtable:area          ; area"
cols_onoff "colrole     ; edtable:role          ; role"
cols_onoff "colnotes    ; edtable:notes         ; notes"

local_table tbl -c $cols -serial -dataTables -sortby g:iname -sortopt {-decreasing}

# vim:fdm=marker
