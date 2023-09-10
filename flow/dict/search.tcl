#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set target [lindex $argv 0]

source at.tcl

set ilist [at_allrows]

set kout [open "rows.f" w]
  foreach i $ilist {
    set name [get_atvar $i,name]
    if [regexp $target $name] {
      puts $kout $i
    }
  }
close $kout

#godel_draw
#exec xdotool search --name "Mozilla" key ctrl+r
