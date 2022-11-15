ghtm_top_bar -save
gnotes "
# $vars(g:pagename)


"

ghtm_newnote
bton_onoff -key level -name level
bton_onoff -key rptto -name rptto
bton_onoff -key D -name D
bton_onoff -key Link -name Link
bton_onoff -key role -name role
bton_onoff -key status -name status
bton_onoff -key fmdate -name fmdate
bton_onoff -key towho -name towho
bton_onoff -key Keywords -name Keywords
bton_onoff -key id -name id
bton_onoff -key Title -name Title
bton_onoff -key name -name name

set     cols ""
cols_onoff "level   ; edtable:level        ; level"
cols_onoff "rptto    ; edtable:rptto         ; rptto"
cols_onoff "D        ; proc:bton_delete      ; D"
cols_onoff "Link     ; proc:ltbl_linkurl url ; Link"
cols_onoff "status   ; edtable:status        ; status"
cols_onoff "fmdate   ; edtable:fmdate        ; fmdate"
cols_onoff "towho    ; edtable:towho         ; towho"
cols_onoff "Keywords ; edtable:keywords      ; Keywords"
cols_onoff "id       ; edtable:id            ; id"
cols_onoff "Title    ; edtable:g:title       ; Title"
cols_onoff "name    ; edtable:name       ; name"
cols_onoff "role    ; edtable:role         ; role"
#

local_table tbl -c $cols -serial -dataTables -sortby g:iname -sortopt {-decreasing} -exclude done


