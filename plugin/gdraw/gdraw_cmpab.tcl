lappend define(installed_flow) cmpab
proc gdraw_cmpab {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name cmpab"
    puts $kout "ghtm_top_bar"
    puts $kout "file mkdir aa"
    puts $kout "file mkdir bb"
    puts $kout "ghtm_list_files aa/*"
    puts $kout "ghtm_list_files bb/*"
    puts $kout "ghtm_list_files *"
  close $kout
}
