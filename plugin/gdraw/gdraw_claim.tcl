#lappend define(installed_flow) claim
proc gdraw_claim {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name claim"
    puts $kout "ghtm_top_bar detail"
    puts $kout "ghtm_table_value_list values"
  close $kout
}
