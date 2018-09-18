lappend define(installed_flow) tbox_col2array
proc gdraw_tbox_col2array {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
  puts $kout "set flow_name tbox_col2array"
  puts $kout "ghtm_top_bar"
  close $kout
}
