lappend define(installed_flow) chkitem
proc gdraw_chkitem {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name chkitem"
    puts $kout "ghtm_top_bar"
    puts $kout "ghtm_paragraph p1"
    puts $kout "ghtm_list_files *"
  close $kout
}
