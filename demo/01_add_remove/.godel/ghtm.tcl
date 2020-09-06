#ghtm_top_bar -save -filter 1
ghtm_top_bar

proc ghtm_js_input {jscmd inputid bid bname} {
  upvar fout fout

  puts $fout "<div>"
  puts $fout "<input type=text id=$inputid>"
  puts $fout "<button id=$bid>$bname</button>"
  puts $fout "<script src=$jscmd></script>"
  puts $fout "</div>"
}

ghtm_js_input add.js    inputid0 bid0 Add
ghtm_js_input remove.js inputid1 bid1 Remove

lappend cols g:pagename
local_table tbl -c $cols


ghtm_list_files *
gnotes {

}
