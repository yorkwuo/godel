lappend define(installed_flow) batch

proc gdraw_batch {} {
  upvar env env
#@>Create 1gen_script.tcl
  set kout [open 1gen_script.tcl w]
puts $kout "#!/usr/bin/tclsh"
puts $kout "source $env(GODEL_ROOT)/bin/godel.tcl"
puts $kout "set bvars(top)   counter"
puts $kout "set bvars(speed) 100"
puts $kout "create_run 01dc dc_env"
puts $kout "set bvars(speed) 200"
puts $kout "create_run 05pt pt_env"
  close $kout
  exec chmod +x 1gen_script.tcl
#@>Create 2summit.tcl
#@>ghtm.tcl
  set kout [open .godel/ghtm.tcl w]
puts $kout "set flow_name batch"
puts $kout "ghtm_top_bar"

  close $kout
}
