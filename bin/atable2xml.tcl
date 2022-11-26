#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set cols $argv

source at.tcl

set rows [at_get_rows]

puts "<record>"
foreach row $rows {
  puts "<row>"

  puts "<port>$row</port>"
  foreach col $cols {
    set value [get_atvar $row,$col]
    puts "<$col>$value</$col>"

  }

  puts "</row>"
}
puts "</record>"
