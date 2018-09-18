lappend define(installed_flow) icc2
lappend define(icc2,filelist) [list "physical.rpt"     "report_design -library -netlist -floorplan -routing"  "icc2_physical"]
lappend define(icc2,filelist) [list "qor.rpt"          "report_qor"                                           "icc2_qor"]
lappend define(icc2,filelist) [list "setup.rpt"          "report_setup"                                           "icc2_setup"]
lappend define(icc2,filelist) [list "hold.rpt"          "report_hold"                                           "icc2_hold"]
lappend define(icc2,filelist) [list "power.rpt"        "report_power"                                         "icc2_power"]
lappend define(icc2,filelist) [list "clocks.rpt"        "report_clocks"                                         "icc2_clocks"]
lappend define(icc2,filelist) [list "util.rpt"         "report_utilization"                                         "icc2_util"]
lappend define(icc2,filelist) [list "legality.rpt"         "report_legality"                                         "icc2_legality"]
lappend define(icc2,filelist) [list "phony"            "calc"                                         "icc2_calc"]
lappend define(icc2,filelist) [list "local.tcl"        "phony"                                                "local config"]

proc gdraw_icc2 {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name icc2"
    puts $kout "ghtm_top_bar detail"
    puts $kout "if \[file exist local.tcl\] {"
    puts $kout "  source local.tcl"
    puts $kout "}"
    puts $kout ""
    puts $kout "if !\[info exist just_draw\] {"
    puts $kout "icc2_qor"
    puts $kout "icc2_physical"
    #puts $kout "icc2_runlog"
    puts $kout "icc2_power"
    puts $kout "icc2_clocks"
    puts $kout "}"
    puts $kout "icc2_calc"
    puts $kout ""
    puts $kout "ghtm_table_value_list values"
    puts $kout "asic4_raw"
    #puts $kout "ghtm_plist srcpath"
    #puts $kout "ghtm_plist liblist"
  close $kout
}
