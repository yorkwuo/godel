ghtm_top_bar -save -new
pathbar 3
gnotes " # $vars(g:pagename)"


set cols ""
lappend cols "ed:kkk;kkk"
lappend cols "ed:nnn;nnn"

local_table tbl -c $cols -serial
