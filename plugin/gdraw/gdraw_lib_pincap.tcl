lappend define(installed_flow) lib_pincap
proc gdraw_lib_pincap {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name lib_pincap"
    puts $kout "ghtm_top_bar"
  close $kout
}
