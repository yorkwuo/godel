lappend define(installed_flow) img_list
proc gdraw_img_list {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name img_list"
    puts $kout "ghtm_top_bar"
    puts $kout "list_img"
  close $kout
}
