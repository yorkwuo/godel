#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set tabfile [lindex $argv 0]

puts "Generating... $tabfile.html"

ghtm_begin $tabfile.html

set kin [open $tabfile r]

set linkfile [file tail $tabfile]
puts $fout "<a href=$linkfile.html type=text/txt>$linkfile.html</a><br>"
puts $fout "<table class=table1>"

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

