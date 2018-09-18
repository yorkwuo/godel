proc write_ptpx_script {} {
  upvar fout fout
  upvar vars vars
  set kout [open cmd.tcl w]

  if ![info exist vars(top)] {
    puts "Error: \$vars(top)"
    puts $kout "Error: \$vars(top)"
    set vars(top) "Error: vars(top)"
  }
# link_path
  puts $kout "set link_path \" \\"
  puts $kout "  * \\"
  puts $kout "  \$target_library \\"
  puts $kout "\""

  puts $kout {
# Section:
suppress_message PWR-806  ;# Skipping clock gating on design
set_app_var sh_continue_on_error                                 false
set_app_var power_enable_analysis                                true 
set_app_var power_enable_multi_rail_analysis                     true 
set_app_var power_analysis_mode                                  averaged 
set_app_var report_default_significant_digits                    3
set_app_var power_enable_clock_scaling                           true
set_app_var power_clock_network_include_register_clock_pin_power false
  }


  puts $kout "
# Section: Read design
read_verilog   $vars(top)
link
current_design $vars(top)
  "

  puts $kout "
# Section: Parasitics Back Annotation
read_parasitics $vars(para_files)
  "

  puts $kout "# Section: Read SDC"
  puts $fout "# Section: Read SDC<br>"
  foreach i $vars(sdc_files) {
    puts $kout "source $i"
  }


  puts $kout "
update_timing -full

save_session pt.session
  "

  puts $kout "
# Section:
set_app_var power_default_toggle_rate        0.1 
set_app_var power_default_static_probability 0.5 

redirect report/check_power.rpt {check_power}

update_power

redirect report/switching_activity.rpt {report_switching_activity}
redirect report/report_power.rpt       {report_power -verbose}
redirect report/clocks.rpt             {report_clocks}
"

#  puts $kout {
## Set 10% toggle rate on clock gates
#set_switching_activity -clock_derate 0.1 -clock_domains [all_clocks] -type clock_gating_cells
#
## Clock Gating & Vth Group Reporting Section
#redirect report/clock_gate_savings.rpt {report_clock_gate_savings}
#
## Set Vth attribute for each library if not set already
#foreach_in_collection l [get_libs] {
#        if {[get_attribute [get_lib $l] default_threshold_voltage_group] == ""} {
#                set lname [get_object_name [get_lib $l]]
#                set_user_attribute [get_lib $l] default_threshold_voltage_group $lname -class lib
#        }
#}
#report_power -threshold_voltage_group > $REPORTS_DIR/${DESIGN_NAME}_pwr.per_lib_leakage
#report_threshold_voltage_group > $REPORTS_DIR/${DESIGN_NAME}_pwr.per_volt_threshold_group
#  }


  close $kout
}
