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
bton_onoff -key level    -name level
bton_onoff -key rptto    -name rptto
bton_onoff -key D        -name D
bton_onoff -key Link     -name Link
bton_onoff -key role     -name role
bton_onoff -key area   -name area
bton_onoff -key fullname -name fullname
bton_onoff -key where    -name where
bton_onoff -key Keywords -name Keywords
bton_onoff -key id       -name id
bton_onoff -key Title    -name Title
bton_onoff -key name     -name name
bton_onoff -key hiername -name hiername

set     cols ""
cols_onoff "level    ; edtable:level         ; level"
cols_onoff "rptto    ; edtable:rptto         ; rptto"
cols_onoff "D        ; proc:bton_delete      ; D"
cols_onoff "Link     ; proc:ltbl_linkurl url ; Link"
cols_onoff "area   ; edtable:area        ; area"
cols_onoff "fullname ; edtable:fullname      ; fullname"
cols_onoff "where    ; edtable:where         ; where"
cols_onoff "Keywords ; edtable:keywords      ; Keywords"
cols_onoff "id       ; edtable:id            ; id"
cols_onoff "Title    ; edtable:g:title       ; Title"
cols_onoff "name     ; edtable:name          ; name"
cols_onoff "hiername ; proc:hiername         ; hiername"
cols_onoff "role     ; edtable:role          ; role"

local_table tbl -c $cols -serial -dataTables -sortby g:iname -sortopt {-decreasing} -exclude done

# vim:fdm=marker
