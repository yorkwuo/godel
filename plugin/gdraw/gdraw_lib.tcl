lappend define(installed_flow)       lib
proc gdraw_lib {} {
  set kout [open .godel/ghtm.tcl w]
  puts $kout "set flow_name lib"
  puts $kout "ghtm_top_bar"

  puts $kout "package require lip"
  puts $kout "set glib \[read_lib timing.lib\]"
  puts $kout "puts \[get_clock_name \$glib\]"
  puts $kout ""
  puts $kout "list_cells \$glib cells.rpt"
  close $kout
}
