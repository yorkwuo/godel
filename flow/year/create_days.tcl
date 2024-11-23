#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set year [lvars . year]
set start_date $year/1/1
set day_counts 365

for {set i 0} {$i < $day_counts} {incr i} {
  puts $i
  set name [exec date "+%Y-%m-%d_%V.%w" -d "$start_date + $i days"]
  file mkdir $name
  godel_draw $name
}
