ghtm_top_bar -save -new
gnotes "
# $vars(g:pagename)


"
#lappend cols "proc:ltbl_iname g:iname ; Name"
lappend cols "edtable:g:pagename      ; g:pagename"
lappend cols "proc:ltbl_lnfile  .godel/ghtm.tcl ghtm      ; ghtm"
lappend cols "edtable:g:keywords      ; Keywords"
local_table tbl -c $cols -serial -dataTables
