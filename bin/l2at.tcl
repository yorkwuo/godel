#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set infile  [lindex $argv 0]
set outfile [lindex $argv 1]

set kin [open "$infile" r]

set count 1
while {[gets $kin line] >= 0} {
  #puts $line
  set c2 [format "%05d" $count]
  set atvar($c2,path) $line
  set atvar($c2,name) [file tail $line]
  incr count
}

close $kin

godel_array_save atvar $outfile
