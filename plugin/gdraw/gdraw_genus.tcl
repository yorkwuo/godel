lappend define(installed_flow)       genus

set     define(genus,import_method_is_copy) 1

lappend define(genus,all_cook)       genus_qor
lappend define(genus,all_cook)       genus_runlog
lappend define(genus,all_cook)       genus_multibit
lappend define(genus,all_cook)       genus_report_clocks
lappend define(genus,all_cook)       genus_clock_gating
lappend define(genus,all_cook)       genus_ref
lappend define(genus,all_cook)       genus_power


lappend define(genus,filelist) [list "qor.rpt"            "qor"           "genus_qor"]
lappend define(genus,filelist) [list "run.log"            "run.log"       "genus_runlog"]
lappend define(genus,filelist) [list "report_clocks.rpt"  "report_clocks" "genus_report_clocks"]
lappend define(genus,filelist) [list "ref.rpt"            ""              "genus_ref"]
lappend define(genus,filelist) [list "power.rpt"          ""              "genus_power"]
lappend define(genus,filelist) [list "multibit.rpt"       ""              "genus_multibit"]
lappend define(genus,filelist) [list "timing.rpt"         "report_timing" "na"]

# vars for genus_report_clocks
set define(ananke,mainclock) coreclk
proc gdraw_genus {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name genus"
    puts $kout "ghtm_top_bar detail"
    puts $kout ""
    puts $kout "if !\[info exist just_draw\] {"
    puts $kout "genus_qor"
    puts $kout "genus_ref"
    puts $kout "genus_power"
    puts $kout "genus_runlog"
    puts $kout "genus_multibit"
    puts $kout "genus_report_clocks"
    puts $kout "genus_clock_gating"
    puts $kout "}"
    puts $kout ""
    puts $kout "genus_calc"
    puts $kout ""
    puts $kout "ghtm_table_value_list values"
    puts $kout "asic4_raw"
    puts $kout ""
    puts $kout "ghtm_plist timing_library"
    puts $kout "ghtm_plist qrc_tech_file"
    puts $kout "ghtm_plist lef_library"
  close $kout
}
