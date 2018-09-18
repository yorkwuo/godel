lappend define(installed_flow) ptpx_env
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

proc gdraw_ptpx_env {} {
  upvar env env

# run.csh
  set kout [open run.csh w]
puts $kout "#!/bin/tcsh -f"
puts $kout "pt_shell -f cmd.tcl | tee report/run.log"
  close $kout
  exec tcsh -fc "chmod +x run.csh"
  exec tcsh -fc "ln -sf report/run.log"

# local.tcl
  if ![file exist local.tcl] {
  set kout [open local.tcl w]
  set_vars target_library                /path/to/target_library
  set_vars top                           top
  set_vars sdc_files                     sdc.tcl
  set_vars para_files                    p1.spef
  close $kout
  }

# ghtm.tcl
  set kout [open .godel/ghtm.tcl w]

puts $kout "set flow_name ptpx_env"
puts $kout "ghtm_top_bar"
puts $kout ""
puts $kout "ghtm_href \"gdraw_ptpx_env.tcl\" \[tbox_cygpath \$env(GODEL_ROOT)/plugin/gdraw/gdraw_ptpx_env.tcl\]"
puts $kout ""
puts $kout "if \[info exist env(DF_GLOBAL)\] {"
puts $kout "  ghtm_href \"DF_GLOBAL\" \$env(DF_GLOBAL)"
puts $kout "  source \$env(DF_GLOBAL)"
puts $kout "} else {"
#puts $kout "  puts \$fout \"No DF_GLOBAL<br>\""
#puts $kout "  puts \"Info: No DF_GLOBAL\""
puts $kout "}"
puts $kout ""
puts $kout "if \[info exist env(DF_LOCAL)\] {"
#puts $kout "  ghtm_href \"DF_LOCAL\" \$env(DF_LOCAL)"
puts $kout "  ghtm_href \"local.tcl\" \$env(DF_LOCAL)"
puts $kout "  source \$env(DF_LOCAL)"
puts $kout "} else {"
#puts $kout "  puts \$fout \"No DF_LOCAL<br>\""
#puts $kout "  puts \"Info: No DF_LOCAL\""
puts $kout "}"
puts $kout ""
puts $kout "if \[info exist vars(sdc_files)\] {"
puts $kout "  foreach i \$vars(sdc_files) {"
puts $kout "    ghtm_href \"\$i\" \$i"
puts $kout "  }"
puts $kout "} else {"
puts $kout "  puts \$fout \"Error: No SDC constraint file \\\$vars(sdc)<br>\""
puts $kout "}"
puts $kout ""
puts $kout "ghtm_href \"write_ptpx_script\" \[tbox_cygpath \$env(GODEL_ROOT)/plugin/ptpx_env/write_ptpx_script.tcl\]"
puts $kout "ghtm_href \"cmd.tcl\" cmd.tcl"
puts $kout ""
puts $kout "file mkdir report"
puts $kout "file mkdir output"
#puts $kout "file mkdir script"
#puts $kout "file mkdir input"
puts $kout ""
puts $kout "write_ptpx_script"

  close $kout
}
