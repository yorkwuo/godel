lappend define(installed_flow)       dir_tree
proc gdraw_dir_tree {} {
  set kout [open .godel/ghtm.tcl w]
  puts $kout "set flow_name dir_tree"
  puts $kout "ghtm_top_bar"
  puts $kout "set target_dir ."
  puts $kout "ghtm_dir_tree 1 1.tree"
  puts $kout "ghtm_dir_tree 2 2.tree"
  puts $kout "ghtm_dir_tree 2 f2.tree \"-D -t -r -f\""
  puts $kout "#ghtm_dir_tree 3 3.tree \"-h -t -f\""
  puts $kout "#ghtm_tree_delete  f2.tree"
  puts $kout "#ghtm_dir_tree 2 f2.tree \"-h -t -f\""
  puts $kout "#-d            List directories only."
  puts $kout "#-h            Print the size in a more human readable way."
  puts $kout "#-D            Print the date of last modification."
  puts $kout "#-t            Sort files by last modification time."
  puts $kout "#-r            Reverse the order of the sort."
  close $kout
}
