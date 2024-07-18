ghtm_top_bar -save

gnotes "#$vars(g:pagename)"


ghtm_panel_begin
  batch_onoff coldel  -name D
  batch_onoff coltick -name T
ghtm_panel_end

set cols ""
cols_onoff "coldel      ; proc:bton_delete   ; D"
cols_onoff "coltick     ; proc:bton_tick     ; T"
lappend cols "ed:class      ; Class"
lappend cols "ed:g:pagename      ; g:pagename"
lappend cols "ed:title      ; Title"
lappend cols "ed:g:keywords ; Keywords"

#local_table tbl -c $cols -serial -sortby "g:iname" -dataTables
local_table tbl -c $cols -serial -sortby "class"

# vim:fdm=marker
