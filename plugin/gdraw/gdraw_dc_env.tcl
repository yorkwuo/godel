lappend define(installed_flow) dc_env
# set_vars
proc set_vars {name defalt_value} {
  upvar kout   kout
  upvar bvars bvars
  if [info exist bvars($name)] {
    puts $kout [format "set %-30s %s" "vars($name)" $bvars($name)]
  } else {
    puts $kout [format "set %-30s %s" "vars($name)" $defalt_value]
  }
}
# gdraw_dc_env
proc gdraw_dc_env {} {
  upvar env   env
  upvar bvars bvars
# run.csh
  set kout [open run.csh w]
puts $kout "#!/bin/tcsh -f"
puts $kout "dc_shell -f cmd.tcl | tee report/run.log"
  close $kout
  exec tcsh -fc "chmod +x run.csh"
  exec tcsh -fc "ln -sf report/run.log"
# local.tcl
  if ![file exist loca.tcl] {
  set kout [open local.tcl w]
# Set default value
  set_vars top                  ttt
  set_vars sdc_files            sdc.tcl 
  set_vars speed                1000
  set_vars mbff                 1
  set_vars rtl_list             rtllist.tcl
  set_vars clock_gating         1
  set_vars phy_syn              1
  set_vars path_group_file      path_group.tcl
  set_vars compile_cmds         compile_ultra
  set_vars target_library       /path/to/ss.lib
  set_vars mw_tech_file         apr/syn.../process.tp
  set_vars mw_reference_library milkyway/vttype/
  set_vars max_tluplus          apr/syn.../max.tluplus
  set_vars min_tluplus          apr/syn.../min.tluplus
  set_vars tech2itf_map         extraction/starrc/.../asic.starrc.map
  close $kout
  }
# ghtm.tcl
  set kout [open .godel/ghtm.tcl w]

puts $kout "set flow_name dc_env"
puts $kout "ghtm_top_bar"
puts $kout ""
puts $kout "ghtm_href \"gdraw_dc_env.tcl\" \[tbox_cygpath \$env(GODEL_ROOT)/plugin/gdraw/gdraw_dc_env.tcl\]"
puts $kout "ghtm_href \"write_dc_script\" \[tbox_cygpath \$env(GODEL_ROOT)/plugin/dc_env/write_dc_script.tcl\]"
puts $kout "ghtm_href \"cmd.tcl\" cmd.tcl"
puts $kout ""
puts $kout "if \[info exist env(DF_GLOBAL)\] {"
puts $kout "  ghtm_href \"DF_GLOBAL\" \$env(DF_GLOBAL)"
puts $kout "  source \$env(DF_GLOBAL)"
puts $kout "} else {"
#puts $kout "  puts \$fout \"No DF_GLOBAL<br>\""
#puts $kout "  puts \"Info: No DF_GLOBAL\""
puts $kout "}"
puts $kout ""
#puts $kout "if \[info exist env(DF_LOCAL)\] {"
#puts $kout "  ghtm_href \"local.tcl\" \$env(DF_LOCAL)"
puts $kout "  ghtm_href \"local.tcl\" local.tcl"
puts $kout "  source local.tcl"
#puts $kout "} else {"
#puts $kout "  puts \$fout \"No DF_LOCAL<br>\""
#puts $kout "  puts \"Info: No DF_LOCAL\""
#puts $kout "}"
puts $kout ""
puts $kout "if \[info exist vars(sdc_files)\] {"
puts $kout "  foreach i \$vars(sdc_files) {"
puts $kout "    ghtm_href \"\$i\" \$i"
puts $kout "  }"
puts $kout "} else {"
puts $kout "  puts \$fout \"Error: No SDC constraint file \\\$vars(sdc)<br>\""
puts $kout "}"
puts $kout ""
puts $kout ""
puts $kout "file mkdir report"
puts $kout "file mkdir output"
#puts $kout "file mkdir script"
#puts $kout "file mkdir input"
puts $kout ""
puts $kout "write_dc_script"

  close $kout
}
