#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set exefile [lindex $argv 0]

if {$exefile eq ""} {
  puts "Usage: goexe.tcl <exefile>"
  return
}

set dirs [glob -nocomplain -type d *]

foreach dir $dirs {
  puts $dir
  if [file exist $dir/$exefile] {
    cd $dir
    exec $exefile
    cd ..
  }
}
