ghtm_top_bar -save
gnotes "
# $vars(g:pagename)


"

ghtm_reset
ghtm_keyword_button tbl Keywords ff

set colgroup [lvars . colgroup]

gnotes {ghtm_set_value}
ghtm_set_value colgroup type1
ghtm_set_value colgroup type2

gnotes {ghtm_onoff}
ghtm_onoff col_name -name name
ghtm_onoff col_bday -name bday


set cols ""
cols_onoff "col_name ; proc:ltbl_iname g:iname ; Name"
cols_onoff "col_bday ; edtable:bday            ; bday"

if {$colgroup eq "type1"} {
  cols_onoff "1 ; edtable:g:keywords ; Keywords"
  cols_onoff "1 ; edtable:tp1        ; typ1"
} elseif {$colgroup eq "type2"} {
  cols_onoff "1 ; edtable:tp2        ; tp2"
}


local_table tbl -c $cols -serial

