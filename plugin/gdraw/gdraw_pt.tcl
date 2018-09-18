lappend define(installed_flow) pt
set define(pt,import_method_is_copy) 1

lappend define(pt,filelist) [list "run.log"           "run file" ""]
lappend define(pt,filelist) [list "qor.rpt"           "qor report" ""]
lappend define(pt,filelist) [list "vios.rpt"          "report_constraint -all -verbose -max_delay -recovery" "godel_ps"]
lappend define(pt,filelist) [list "timing_detail.rpt" "report_timing -tran -cap -nets -derate -nosplit -path full_clock_expanded -cross -max_paths 50 -nworst 5" ""]


proc gdraw_pt {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name pt"
    puts $kout "ghtm_top_bar detail"
    puts $kout "if \[file exist local.tcl\] {"
    puts $kout "  source local.tcl"
    puts $kout "}"
    puts $kout ""
    puts $kout "if !\[info exist just_draw\] {"
    puts $kout "dc_qor"
    puts $kout "godel_ps wc snps vios.rpt"
    #puts $kout "pt_runlog"
    #puts $kout "pt_clocks"
    puts $kout "}"
    #puts $kout "pt_calc"
    puts $kout ""
    puts $kout "ghtm_table_value_list values"
    puts $kout "asic4_raw"
    puts $kout "ghtm_plist srcpath"
    puts $kout "ghtm_plist liblist"

  close $kout
}
