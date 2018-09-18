lappend define(installed_flow)       dc
set define(dc,import_method_is_copy) 1
lappend define(dc,filelist) [list "run.log"          "run file"                                             "dc_runlog"]
lappend define(dc,filelist) [list "timing.rpt"       "report_timing -max -tran -split"                      "dc_timing"]
lappend define(dc,filelist) [list "qor.rpt"          "report_qor"                                           "dc_qor"]
lappend define(dc,filelist) [list "area.rpt"         "report_area"                                          "dc_area"]
lappend define(dc,filelist) [list "printvar.rpt"     "printvar"                                             "dc_printvar"]
lappend define(dc,filelist) [list "ref.rpt"          "report_reference -nosplit"                            "dc_ref"]
lappend define(dc,filelist) [list "derate.rpt"       "report_timing_derate"                                 "dc_derate"]
lappend define(dc,filelist) [list "vios.rpt"         "report_constraint -all -verbose -max_delay"           "dc_vios"]
lappend define(dc,filelist) [list "mbff.rpt"         "report_multibit_banking"                              "dc_mbff"]
lappend define(dc,filelist) [list "clock_gating.rpt" "report_clock_gating"                                  "dc_clock_gating"]
lappend define(dc,filelist) [list "clocks.rpt"       "report_clocks -nosplit"                               "dc_clocks"]
lappend define(dc,filelist) [list "power.rpt"        "report_power"                                         "dc_power"]
lappend define(dc,filelist) [list "phony1"           "phony"                                                "dc_calc"]
lappend define(dc,filelist) [list "local.tcl"        "phony"                                                "local config"]
proc gdraw_dc {} {
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name dc"
    puts $kout "ghtm_top_bar detail"
    puts $kout "if \[file exist local.tcl\] {"
    puts $kout "  source local.tcl"
    puts $kout "}"
    puts $kout ""
    puts $kout "if !\[info exist just_draw\] {"
    puts $kout "dc_area"
    puts $kout "dc_clock_gating"
    puts $kout "dc_derate"
    puts $kout "dc_mbff"
    puts $kout "dc_printvar"
    puts $kout "dc_qor"
    puts $kout "dc_runlog"
    puts $kout "dc_vios"
    puts $kout "dc_clocks"
    puts $kout "dc_ref"
    puts $kout "dc_timing"
    puts $kout "dc_power"
    puts $kout "}"
    puts $kout "dc_calc"
    puts $kout ""
    puts $kout "ghtm_table_value_list values"
    puts $kout "asic4_raw"
    puts $kout "ghtm_plist srcpath"
    puts $kout "ghtm_plist liblist"
  close $kout
}
