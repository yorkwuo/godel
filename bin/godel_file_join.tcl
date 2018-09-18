#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
foreach i $argv {
  set fin [open $i r]
    puts "#file::$i"
    while {[gets $fin line] >= 0} {
      puts $line
    }
  close $fin
}

