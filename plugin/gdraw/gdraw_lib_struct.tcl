lappend define(installed_flow) lib_struct

proc gdraw_lib_struct {} {
  set kout [open .godel/ghtm.tcl w]

  puts $kout "set inlib timing.lib"
  puts $kout "set flow_name lib"
  puts $kout "ghtm_top_bar"
  puts $kout "package require lip"
  puts $kout ""
  puts $kout "file_not_exist_exit \$inlib"
  puts $kout ""
  puts $kout "set glib \[read_lib \$inlib\]"
  puts $kout ""
  puts $kout "puts \$fout \[get_group_name \$glib\]<br>"
  puts $kout "#puts \$fout \[get_clock_name \$glib\]<br>"
  puts $kout ""
  puts $kout "list_cells     \$glib celllist.rpt"
  puts $kout "lip_list_index \$glib tran index.rpt"
  puts $kout "lip_list_index \$glib load index.rpt"
  puts $kout "list_hier      \$glib 3    hier3.rpt"

  close $kout
}
