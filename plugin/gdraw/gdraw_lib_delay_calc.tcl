lappend define(installed_flow) lib_delay_calc
proc gdraw_lib_delay_calc {} {
  set kout [open .godel/ghtm.tcl w]
  puts $kout "set flow_name lib_delay_calc"
  puts $kout "ghtm_top_bar"

  puts $kout "package require lip"
  puts $kout "return"
  puts $kout "set glib \[read_lib timing.lib\]"
  puts $kout ""
  puts $kout "list_cells \$glib cells.rpt"
  puts $kout "set gcell \[get_cell \$glib d04ani02wn0d0\]"
  puts $kout "set gpin \[get_pin \$gcell o\]"
  puts $kout "set gp \[get_subgroup_of_type_with_attr \$gpin timing timing_type rising_edge\]"
  puts $kout "set g \[get_subgroup_of_type \$gp cell_rise\]"
  puts $kout "lip_LU_table_interpolate \$g 4.0 1.2"


  close $kout
}
