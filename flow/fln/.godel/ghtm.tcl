ghtm_top_bar -save -new -anew
gnotes "
# $vars(g:pagename)
"
if [file exist "pretxt.tcl"] {
  puts $fout "<a href=pretxt.tcl type=text/txt>pretxt.tcl</a>"
  source pretxt.tcl
}
mod_flist
mod_links

# Notes
gnotes {## Notes}

set cols ""
lappend cols "ed:g:pagename;Title"
lappend cols "ed:notes;Notes"
lappend cols "ed:g:keywords;Keywords"

local_table tbl -c $cols -serial

if [file exist "posttxt.tcl"] {
  puts $fout "<a href=posttxt.tcl type=text/txt>posttxt.tcl</a>"
  source posttxt.tcl
}
# vim:fdm=marker
