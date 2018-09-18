proc write_pt_script {} {
  upvar fout fout
  upvar vars vars
  set kout [open cmd.tcl w]

  if ![info exist vars(top)] {
    puts "Error: \$vars(top)"
    puts $kout "Error: \$vars(top)"
    set vars(top) "Error: vars(top)"
  }
# link_library
  puts $kout "set link_library \" \\"
  puts $kout "  * \\"
  puts $kout "\""

  puts $kout {
#@>set_app_var
suppress_message PWR-806  ;# Skipping clock gating on design
set_app_var sh_continue_on_error                 false
set_app_var pba_exhaustive_endpoint_path_limit   infinity         
set_app_var delay_calc_waveform_analysis_mode    full_design
set_app_var timing_aocvm_enable_analysis         true ; # Enabling AOCV analysis
set_app_var timing_ocvm_enable_distance_analysis true ;# Enabling AOCV distance based analysis
set_app_var read_parasitics_load_locations       true
set_app_var report_default_significant_digits    3 ;
# POCV eable
set_app_var read_parasitics_load_locations       true; # default false
set_app_var timing_pocvm_enable_analysis         true; # default false
set_app_var timing_pocvm_corner_sigma            3   ; # default 3
set_app_var timing_enable_constraint_variation   true; # default false, setup/hold variation
set_app_var timing_enable_slew_variation         true; # default false, slew variation
#set sh_source_uses_search_path           true ;
#set search_path ". $search_path" ;
  }

#@>Read Design
  puts $kout "
# Section: Read design
read_verilog   $vars(netlist)
current_design $vars(top)
link
  "
#@>Read Parasitics
  puts $kout "
# Section: Parasitics Back Annotation
read_parasitics $vars(para_files)
  "

#@>Read SDC
  puts $kout "
source $vars(sdc_files)
  "

  puts $kout "
read_ocvm $vars(aocvm_files)
  "


  puts $kout {
#set_timing_derate $derate_clock_early_value -clock -early
#set_timing_derate $derate_clock_late_value  -clock -late
#set_timing_derate $derate_data_early_value  -data -early
#set_timing_derate $derate_data_late_value   -data -late
  }

  puts $kout "
set timing_remove_clock_reconvergence_pessimism true 
update_timing -full

save_session pt.session
  "

  puts $kout "
#@>Report
redirect report/qor.rpt          {report_qor           }
redirect report/printvar.rpt     {printvar             }
redirect report/derate.rpt       {report_timing_derate }
redirect report/vios.rpt         {report_constraint -all -verbose -max_delay -nosplit}
redirect report/timing.rpt       {report_timing -tran -cap -max_paths 50 -nosplit}
  "

  close $kout
}
