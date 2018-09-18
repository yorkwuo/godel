lappend define(installed_flow) split_proc
proc gdraw_split_proc {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set input input.tcl"
    puts $kout "set flow_name split_proc"
    puts $kout "ghtm_top_bar"
    puts $kout "godel_split_proc \$input oo"
    puts $kout "#godel_merge_proc \$input merged.tcl"
  close $kout
}
