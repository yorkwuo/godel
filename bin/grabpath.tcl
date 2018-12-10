#!/usr/bin/tclsh
set infile [lindex $argv 0]
if {$infile == ""} {
  puts "Error: No input file."
  return
}

set kin [open $infile r]

  while {[gets $kin line] >= 0} {
    set matches [regexp -all -inline {[0-9a-zA-Z\-./_]+/[0-9a-zA-Z\-./_]+} $line]
    foreach i $matches {
      puts $i
    }
  }

close $kin
