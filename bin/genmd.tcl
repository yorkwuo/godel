#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

set fname [lindex $argv 0]

if {$fname == ""} {
  puts "% gndmd.tcl name"
  return
}
set kout [open $fname.md w]
puts $kout "# $fname"
puts $kout ""
puts $kout "<a href=$fname.md type=text/txt>edit</a>"
puts $kout ""
puts $kout "@? $fname"

puts $kout ""
close $kout
