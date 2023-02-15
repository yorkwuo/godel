#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
source at.tcl

set save [lindex $argv 0]

set rows [at_allrows]

foreach row $rows {
  set value [get_atvar $row,id]
  if {$value eq "NA"} {
    set atvar($row,id) $row
  }
}

if {$save eq "-save"} {
  godel_array_save atvar at.tcl
}
