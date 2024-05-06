#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

# -h (header)
# {{{
  set opt(-h) 0
  set idx [lsearch $argv {-h}]
  if {$idx != "-1"} {
    set argv [lreplace $argv $idx $idx]
    set opt(-h) 1
  }
# }}}
  # -c (column)
# {{{
  set opt(-c) 0
  set idx [lsearch $argv {-c}]
  if {$idx != "-1"} {
    set colindex [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-c) 1
  }
# }}}
  # -f (filter)
# {{{
  set opt(-f) 0
  set idx [lsearch $argv {-f}]
  if {$idx != "-1"} {
    set filter [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-f) 1
  }
# }}}

set fname [lindex $argv 0]

if {$fname eq ""} {
  puts "Usage: csv.tcl <fname.csv>"
  puts "Usage: csv.tcl -c 4 fname.csv -f \"3 foobar\""
  return
}

#-----------------------------------------------
# -h (header)
#-----------------------------------------------
if {$opt(-h) eq "1"} {
  set line [exec head -n 1 $fname]
  set cols [split $line ","]
  
  set counter 0
  foreach col $cols {
    set num [format "%2d" $counter]
    puts "$num $col"
    incr counter
  }
  return
}

set lines [read_as_list $fname]

foreach line $lines {
  set cs [split $line ","]
  set f_col [lindex $filter 0]
  set f_kw  [lindex $filter 1]
  set value [lindex $cs $f_col]
  if [regexp $f_kw $value] {
    puts [lindex $cs $colindex]
  }
}



# vim:fdm=marker
