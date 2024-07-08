ghtm_top_bar -save -new
pathbar 3
#gnotes " # $vars(g:pagename) "

gmd 1.md

if [file exist "pretxt.tcl"] {
  puts $fout "<a href=pretxt.tcl type=text/txt>pretxt.tcl</a>"
  source pretxt.tcl
}
mod_flist
mod_links

# Notes
puts $fout "<div>Notes</div>"

set cols ""
lappend cols "proc:bton_delete;D"
lappend cols "ed:g:pagename;g:pagename"
lappend cols "ed:notes;Notes"
lappend cols "ed:g:keywords;Keywords"

local_table tbl -c $cols -serial

if [file exist "posttxt.tcl"] {
  puts $fout "<a href=posttxt.tcl type=text/txt>posttxt.tcl</a>"
  source posttxt.tcl
}
# vim:fdm=marker
