#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set tabfile [lindex $argv 0]


ghtm_begin $tabfile.htm 

set kin [open $tabfile r]

puts $fout "<table class=table2>"

while {[gets $kin line] > 0} {
  puts $fout "<tr>"

  set cols [split $line "\t"]

  foreach col $cols {
    puts -nonewline $fout "<td>$col</td>"
  }
  puts $fout ""
  #puts [lindex $cols 0]
  puts $fout "</tr>"
}

puts $fout "</table>"

close $kin

ghtm_end

