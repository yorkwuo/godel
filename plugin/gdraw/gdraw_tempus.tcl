lappend define(installed_flow)       tempus

set     define(tempus,import_method_is_copy) 1

lappend define(tempus,filelist) [list "timing.rpt"  "report_timing" "tempus_timeDesign"]
lappend define(tempus,filelist) [list "vios.rpt"    "report_constraint" "tempus_timing_reg2reg"]

proc gdraw_tempus {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name tempus"
    puts $kout "ghtm_top_bar detail"
    puts $kout ""
    puts $kout "if !\[info exist just_draw\] \{"
    puts $kout "godel_ps 002 cdn"
    puts $kout "\}"
    puts $kout "tempus_calc"
    puts $kout "tempus_se_pairs"
    puts $kout ""
    puts $kout "ghtm_table_value_list values"
    puts $kout ""
    puts $kout "ghtm_list_files *.rpt"
    puts $kout "ghtm_plist srcpath"
  close $kout
}
