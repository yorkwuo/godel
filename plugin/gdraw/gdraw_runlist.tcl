lappend define(installed_flow) runlist
proc gdraw_runlist {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name runlist"
    puts $kout "ghtm_top_bar"
    puts $kout "# Create vv.tcl"
    puts $kout "grun_ls"
    puts $kout "#grun_ls {01dc|05pt}"
    puts $kout ""
    puts $kout "source vv.tcl"
    puts $kout ""
    puts $kout "array set vars \[array get vv\]"
    puts $kout "set rowlist \$vars(rowlist)"
    puts $kout ""
    puts $kout "lappend columnlist runname"
    puts $kout "lappend columnlist status"
    puts $kout "lappend columnlist top"
    puts $kout "lappend columnlist speed"
    puts $kout ""
    puts $kout "ghtm_table_nodir runlist 0"
    puts $kout ""
    puts $kout "godel_array_reset vars"

  close $kout
}
