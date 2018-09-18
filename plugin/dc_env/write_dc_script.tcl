proc write_dc_script {} {
  upvar fout fout
  upvar vars vars

# rtllist.tcl
  if ![file exist sdc.tcl] {
    set kout [open rtllist.tcl w]
    close $kout
  }

# sdc.tcl
  if ![file exist sdc.tcl] {
    set kout [open sdc.tcl w]
    close $kout
  }

# cmd.tcl
  set kout [open cmd.tcl w]

  if ![info exist vars(top)] {
    puts "Error: \$vars(top)"
    puts $kout "Error: \$vars(top)"
    set vars(top) "Error: vars(top)"
  }
# target_library
  puts $kout {
source $env(GODEL_ROOT)/bin/godel.tcl
grun_status "begin"
  }
  puts $kout "set target_library \{ \\"
      if [info exist vars(target_library)] {
        foreach i $vars(target_library) {
          puts $kout "  $i \\"
        }
      } else {
        puts $kout "  Error: \$vars(target_library) not exist ..."
        puts "  Error: \$vars(target_library) not exist ..."
      }
  puts $kout "\}"
# synthetic_library
  puts $kout "set synthetic_library dw_foundation.sldb"
# link_library
  puts $kout "set link_library \" \\"
  puts $kout "  * \\"
  puts $kout "  \$target_library \\"
  puts $kout "  \$synthetic_library \\"
  puts $kout "\""

  puts $kout {
# Section:
suppress_message CMD-041  ;# new variable
suppress_message OPT-1206 ;# is a constant and will be removed
suppress_message PWR-806  ;# Skipping clock gating on design
set_app_var sh_continue_on_error                   false
set_app_var enable_page_mode                       false
set_app_var report_default_significant_digits      0
set_app_var write_name_nets_same_as_ports          true
set_app_var enable_ao_synthesis                    true
set_app_var mv_insert_level_shifters_on_ideal_nets all
set_app_var auto_insert_level_shifters_on_clocks   all
set_app_var uniquify_naming_style                  %s_%d
set_app_var verilogout_no_tri                      true
set_app_var verilogout_single_bit                  false
set_app_var verilogout_show_unconnected_pins       true
set_app_var verilogout_higher_designs_first        false
set_app_var enable_recovery_removal_arcs           true
set_app_var hdlin_preserve_sequential              all
set_app_var link_force_case                        case_insensitive
set_app_var uniquify_keep_original_design          true
set_app_var allow_newer_db_files                   true
set_app_var change_names_dont_change_bus_members   false
set_app_var rc_driver_model_mode                   advanced
set_app_var rc_receiver_model_mode                 advanced
set_app_var compile_clock_gating_through_hierarchy true
set_app_var cache_write                            ./.synopsys_cache
set_app_var cache_read                             ./.synopsys_cache
set_app_var cache_file_chmod_octal                 777
set_app_var cache_dir_chmod_octal                  777

define_design_lib          WORK -path ./work
set_svf                    output/formal.svf
  }
# mbff
if {$vars(mbff)} {
  puts $kout "# mbff"
  puts $kout "set_app_var hdlin_infer_multibit default_all"
}
# physical synthesis
if {$vars(phy_syn)} {
  puts $kout "# Section: Create Milkyway"
  puts $fout "# Section: Create Milkyway<br>"
  puts $kout "file mkdir mwdb"
  puts $kout "extend_mw_layers"
  puts $kout "create_mw_lib \\"
  puts $kout "  -technology           $vars(mw_tech_file) \\"
  puts $kout "  -mw_reference_library $vars(mw_reference_library) \\"
  puts $kout "  ./mwdb/design_lib"
  puts $kout "open_mw_lib"
  puts $kout "set_tlu_plus_files \\"
  puts $kout "  -max_tluplus  $vars(max_tluplus) \\"
  puts $kout "  -min_tluplus  $vars(min_tluplus) \\"
  puts $kout "  -tech2itf_map $vars(tech2itf_map)"
}
# Read RTL
  puts $kout ""
  puts $kout "# Section: Read RTL files"
  puts $fout "# Section: Read RTL files<br>"
  puts $kout "source $vars(rtl_list)"
  puts $kout "elaborate $vars(top) > report/elab.rpt"
  puts $kout "uniquify"
  puts $kout {
link                > report/link.rpt
set_fix_multiple_port_nets -all
  }
  puts $kout "current_design $vars(top)"

# ICG: clock gating
if {$vars(clock_gating)} {
  puts $kout "
set_clock_gating_style   \\
    -max_fanout          16 \\
    -minimum_bitwidth    8 \\
    -control_point       before \\
    -positive_edge_logic integrated \\
    -no_sharing          \\
    -control_signal      test_mode
  "
} else {
  puts $kout "# Info: No clock gating"
}

# Read SDC
  puts $kout "# Section: Read SDC"
  puts $fout "# Section: Read SDC<br>"
  foreach i $vars(sdc_files) {
    puts $kout "source $i"
  }

  #puts $kout "\n# Section: Path Group"
  #puts $kout "source $vars(path_group_file)"
  puts $kout {

  }

if {$vars(mbff)} {
  puts $kout "# mbff"
  puts $kout "set_multibit_options -mode timing_driven"
}

  puts $kout {
grun_status "compile"
  }
# Compile
  puts $kout "
# Section:
$vars(compile_cmds)
#compile_ultra -timing_high_effort_script -gate_clock -scan
#compile_ultra -incremental -timing_high_effort_script
  "

  puts $kout {
define_name_rules namerule \
    -add_dummy_nets \
    -allow "A-Za-z0-9_\[\]" \
    -equal_ports_nets \
    -flatten_multi_dimension_busses \
    -remove_internal_net_bus \
    -target_bus_naming_style "%s\[%d\]"

define_name_rules regname \
    -type cell \
    -map {{{"\]", "_"}, {"\[", "_"}}}

change_names -hier -verbose -rules namerule > ./report/change_names_namerule.log
change_names -hier -verbose -rules regname  > ./report/change_names_regname.log
  }

if {$vars(phy_syn)} {
  puts $kout "
write_parasitics -output output/$vars(top).spef
  "
}
  puts $kout "
# Section:
# Write SVF file
set_svf off
write_file -format verilog -output output/$vars(top).v
write_file -format ddc     -output output/$vars(top).ddc

# Section:
redirect report/area.rpt         {report_area          }
redirect report/qor.rpt          {report_qor           }
redirect report/printvar.rpt     {printvar             }
redirect report/ref.rpt          {report_reference     }
redirect report/derate.rpt       {report_timing_derate }
redirect report/vios.rpt         {report_constraint -all -verbose -max_delay -nosplit}
redirect report/clock_gating.rpt {report_clock_gating}
redirect report/clocks.rpt       {report_clocks}
redirect report/power.rpt        {report_power}
redirect report/timing.rpt       {report_timing -tran -cap -max_paths 50 -nosplit}
  "
if {$vars(mbff)} {
  puts $kout "
redirect report/mbff.rpt         {report_multibit_banking}
redirect report/mbff_detail.rpt  {report_multibit}
"
}

  puts $kout {
grun_status "done"
  }

  close $kout
}
