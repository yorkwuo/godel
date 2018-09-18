lappend define(installed_flow) lib_leakage
proc gdraw_lib_leakage {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name lib_leakage"
    puts $kout "ghtm_top_bar"
  close $kout
}
