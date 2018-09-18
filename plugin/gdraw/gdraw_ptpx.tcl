lappend define(installed_flow) ptpx
set define(ptpx,import_method_is_copy) 1

lappend define(ptpx,filelist) [list "run.log"          "run file"                   "ptpx_runlog"]
lappend define(ptpx,filelist) [list "printvar.rpt"     "printvar"                   "ptpx_printvar"]
lappend define(ptpx,filelist) [list "clocks.rpt"       "report_clocks -nosplit"     "ptpx_clocks"]
lappend define(ptpx,filelist) [list "power.rpt"        "report_power"               "ptpx_power"]
lappend define(ptpx,filelist) [list "phony1"           "phony"                      "ptpx_calc"]
lappend define(ptpx,filelist) [list "local.tcl"           "phony"                   "local config"]
proc gdraw_ptpx {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name ptpx"
    puts $kout "ghtm_top_bar detail"
    puts $kout "if \[file exist local.tcl\] {"
    puts $kout "  source local.tcl"
    puts $kout "}"
    puts $kout ""
    puts $kout "if !\[info exist just_draw\] {"
    puts $kout "ptpx_runlog"
    puts $kout "ptpx_power"
    puts $kout "ptpx_clocks"
    puts $kout "}"
    puts $kout "ptpx_calc"
    puts $kout ""
    puts $kout "ghtm_table_value_list values"
    puts $kout "asic4_raw"
    puts $kout "ghtm_plist srcpath"
    puts $kout "ghtm_plist liblist"

  close $kout
}
