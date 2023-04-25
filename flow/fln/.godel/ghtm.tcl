ghtm_top_bar -save
gnotes "
# $vars(g:pagename)
"
if [file exist "pretxt.tcl"] {
  puts $fout "<a href=pretxt.tcl type=text/txt>pretxt.tcl</a>"
  source pretxt.tcl
}
# File list
#gnotes {## File list}

gexe_button update.tcl -name filelist -nowin
set atcols  ""
lappend atcols "proc:bton_fdelete flist.tcl ; FD"
lappend atcols "Vs;Vs"
lappend atcols "last;last"
lappend atcols "mtime;mtime"
lappend atcols "proc:at_open flist.tcl ; O"
lappend atcols "name;name"

atable flist.tcl -tableid tbl1 -noid -num

# Links
#gnotes {## Links}
if [info exist atrows] { unset atrows }

gexe_button newlink.tcl -name newlink -nowin

if [file exist links.tcl] { source links.tcl }

set atcols ""
lappend atcols "proc:bton_delete ; D"
lappend atcols "ed:type           ; type"
lappend atcols "proc:alinkname ; name"
lappend atcols "proc:alinkurl    ; url"

atable links.tcl -noid -sortby id -tableid tbl2

# Notes
#gnotes {## Notes}

gexe_button newnote.tcl -name newnote -nowin

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
