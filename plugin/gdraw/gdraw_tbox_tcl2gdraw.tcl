lappend define(installed_flow)      tbox_tcl2gdraw
proc gdraw_tbox_tcl2gdraw {} {
  set kout [open .godel/ghtm.tcl w]

  puts $kout "set infile input.tcl"
  puts $kout ""
  puts $kout "set flow_name plot"
  puts $kout "ghtm_top_bar"
  puts $kout ""
  puts $kout "file_not_exist_exit \$infile"
  puts $kout ""
  puts $kout "tbox_tcl2gdraw \$infile"
  close $kout
}
