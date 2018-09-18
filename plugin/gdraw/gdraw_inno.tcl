lappend define(installed_flow)       inno

set     define(inno,import_method_is_copy) 1

lappend define(inno,filelist) [list "timeDesign.rpt"        "timeDesign format file" "inno_timeDesign"]
lappend define(inno,filelist) [list "timing_reg2reg.rpt"    "report_timing" "inno_timing_reg2reg"]

proc gdraw_inno {} {
  set kout [open .godel/ghtm.tcl w]
  puts $kout "set flow_name inno"
     puts $kout "ghtm_top_bar detail"
     puts $kout "#ghtm_paragraph p1"
     puts $kout "#ghtm_table_note TableNmae .index.htm"
     puts $kout "#ghtm_table_nodir history 0"
     puts $kout "#ghtm_list_files"
     puts $kout "inno_timeDesign"
     #puts $kout "dc_area"
     puts $kout "inno_timing_reg2reg"
     puts $kout "ghtm_table_value_list values"
  close $kout
}
