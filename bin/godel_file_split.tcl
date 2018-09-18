#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

set ifile [lindex $argv 0]
set fin [open $ifile r]

set num 0
while {[gets $fin line] >=0} {
  if {[regexp {^#file::} $line]} {
    incr num
  }
  lappend curs($num,all) $line
}
close $fin
set curs(size) $num
puts $num

for {set i 1} {$i <= $curs(size)} {incr i} {
  set file_name_line [lindex $curs($i,all) 0]
  regexp {^#file::(\S+)} $file_name_line whole file_name
  puts $file_name
  set fout [open $file_name w]
    foreach line $curs($i,all) {
      if [regexp {^#file::} $line] {
      } else {
        puts $fout $line
      }
    }
  close $fout
}
