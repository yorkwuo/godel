ghtm_top_bar -save
gnotes "
# $vars(g:pagename)


"
lappend cols "proc:ltbl_iname g:iname ; Name"
lappend cols "edtable:g:pagename      ; title"
lappend cols "proc:ltbl_lnfile  .godel/ghtm.tcl ghtm      ; ghtm"
lappend cols "edtable:g:keywords      ; Keywords"
local_table tbl -c $cols
