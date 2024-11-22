#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
#set opt(-start) 0
#set idx [lsearch $argv {-start}]
#if {$idx != "-1"} {
#  set start_date [lindex $argv [expr $idx + 1]]
#  set argv [lreplace $argv $idx [expr $idx+1]]
#  set opt(-start) 1
#}
##puts $start_date
#if ![info exist start_date] {
#  set start_date [clock format [clock seconds] -format {%Y-%m-%d}]
#}
#
#set day_counts [lindex $argv 0]
#
#if {$day_counts == ""} {
#  puts "Usage:"
#  puts "% newdate.tcl 7"
#  puts "% newdate.tcl 7 -start 2013/3/3"
#}

#puts [exec date +"%Y-%m-%d-%a"]
set start_date 2024/1/1
set day_counts 365
for {set i 0} {$i < $day_counts} {incr i} {
  puts $i

  #set name [exec date "+%w" -d "$start_date + $i days"]
  #if {$name eq "0"} {
  #  #puts $name
  #  set dd [exec date "+%Y-%m-%d_%V.%w" -d "$start_date + $i days"]
  #  lsetvar $dd bgcolor pink
  #}
  set name [exec date "+%Y-%m-%d_%V.%w" -d "$start_date + $i days"]
  #puts $name
  file mkdir $name
  godel_draw $name

  #puts "gmkdir $name"

}
