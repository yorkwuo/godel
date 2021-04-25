#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

#set dir_pattern [lindex $argv 0]
set keyname     [lindex $argv 0]

#puts $keyname

set dirs [glob -nocomplain -type d *]

foreach dir $dirs {
  puts "#$dir"
  set value [lvars $dir $keyname]
  if {$value eq "NA"} {
    lsetvar $dir $keyname ""
  }
}
