proc gdraw_default {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "ghtm_top_bar"
    puts $kout "#ghtm_list_files *"
    puts $kout "#list_img"
    puts $kout "#ghtm_filter_notes"
    puts $kout "gnotes {"
    puts $kout ""
    puts $kout "}"
  close $kout
}
