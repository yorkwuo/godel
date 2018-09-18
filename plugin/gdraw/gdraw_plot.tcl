lappend define(installed_flow)       plot
proc gdraw_plot {} {
  set kout [open .godel/ghtm.tcl w]
  puts $kout "set flow_name plot"
  puts $kout "ghtm_top_bar"
  puts $kout ""
  puts $kout "#ghtm_histogram_scatter"
  puts $kout "#ghtm_histogram_accu"
  close $kout
}
