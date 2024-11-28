ghtm_top_bar
pathbar 3

if ![file exist "1.svg"] {
  set kout [open "1.svg" w]
    puts $kout {<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="1000" height="10">}
    puts $kout {</svg>}
  close $kout
}

set pagename [lvars . g:pagename]

puts $fout {<div class=top>}

puts $fout {<div id=toc-container>}
puts $fout {  <div id=toc>}
if [file exist cover.png] {
  puts $fout {  <div><img src=cover.png width=180px></div>}
} else {
  puts $fout "<div style='font-size:40px;text-align:center'>$pagename</div>"
}
#puts $fout {  <div><a style="text-decoration:none" href=#notes>Notes</a></div>}
#puts $fout {  <div><a style="text-decoration:none" href=#filelist>Filelist</a></div>}
#puts $fout {  <div><a style="text-decoration:none" href=#links>Links</a></div>}
#puts $fout {  <div><a style="text-decoration:none" href=#pages>Pages</a></div>}
puts $fout {  <ol id=toc-list>}
set dirs [lsort [glob -nocomplain -type d *]]
foreach dir $dirs {
  set pagename [lvars $dir g:pagename]
  puts $fout "<li><a style=\"text-decoration:none;white-space:pre\" href=$dir/.index.htm>$pagename</a></li>"
}
puts $fout {
    </ol>
  </div>
</div>
}


puts $fout {<div id="content">}

#ghtm_kvp g:pagename
#set rows ""
#lappend rows g:pagename
#var_table

#if ![file exist "1.md"] {
#  set kout [open "1.md" w]
#    puts $kout "# Notes"
#  close $kout
#}
#gmd 1.md

list_svg 1.svg

if [file exist "pretxt.tcl"] {
  puts $fout "<a href=pretxt.tcl type=text/txt>pretxt.tcl</a>"
  source pretxt.tcl
}
mod_flist
mod_links

# Notes
set cwd [pwd]
puts $fout "<div id=pages class=scrolltop style='cursor:pointer' onclick=\"cmdline('$cwd','tclsh','$env(GODEL_ROOT)/tools/server/tcl/newpage.tcl')\">Pages</div>"

set cols ""
lappend cols "proc:bton_delete     ; D"
lappend cols "ed:type              ; Type"
lappend cols "proc:ltbl_cover 80px ; Cover"
lappend cols "ed:g:pagename        ; g:pagename"
lappend cols "ed:notes             ; Notes"
#lappend cols "ed:g:keywords        ; Keywords"

local_table tbl -c $cols -serial

if [file exist "posttxt.tcl"] {
  puts $fout "<a href=posttxt.tcl type=text/txt>posttxt.tcl</a>"
  source posttxt.tcl
}

puts $fout {</div>}
puts $fout {</div>}

# vim:fdm=marker
