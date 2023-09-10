#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set next [lvars . next]

set kout [open "next.csh" "w" 0766]

puts $kout "#!/bin/csh -f"
foreach n $next {
  puts $kout "cd ../$n; run.csh &"
}

close $kout
