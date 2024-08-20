ghtm_top_bar
pathbar 3
if [file exist "cover.png"] {
  puts $fout {<img src=cover.png height=120px style=float:right>}
}
if ![file exist "1.md"] {
  set kout [open "1.md" w]
    puts $kout "# Notes"
  close $kout
}
gmd 1.md

if [file exist "pretxt.tcl"] {
  puts $fout "<a href=pretxt.tcl type=text/txt>pretxt.tcl</a>"
  source pretxt.tcl
}
mod_flist
mod_links

# Notes
set cwd [pwd]
puts $fout "<div style='cursor:pointer' onclick=\"cmdline('$cwd','tclsh','/home/github/godel/tools/server/tcl/newpage.tcl')\">Pages</div>"

set cols ""
lappend cols "proc:bton_delete     ; D"
lappend cols "proc:ltbl_cover 80px ; cover"
lappend cols "ed:g:pagename        ; g:pagename"
lappend cols "ed:notes             ; Notes"
lappend cols "ed:g:keywords        ; Keywords"

local_table tbl -c $cols -serial

if [file exist "posttxt.tcl"] {
  puts $fout "<a href=posttxt.tcl type=text/txt>posttxt.tcl</a>"
  source posttxt.tcl
}
# vim:fdm=marker
