lappend define(installed_flow) pagelist

proc gdraw_pagelist {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name pagelist"
    puts $kout "ghtm_top_bar"
    puts $kout ""
    puts $kout "ghtm_filter_table pagelist 3"
    puts $kout "pagelist"

  close $kout
}
