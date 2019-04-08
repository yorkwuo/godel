#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
# -k (key)
set opt(-k) 0
set idx [lsearch $argv {-k}]
if {$idx != "-1"} {
  set key  [lindex $argv [expr $idx + 1]]
  set argv [lreplace $argv $idx [expr $idx + 1]]
  set opt(-k) 1
}
# -v (value)
set opt(-v) 0
set idx [lsearch $argv {-v}]
if {$idx != "-1"} {
  set value [lindex $argv [expr $idx + 1]]
  set argv  [lreplace $argv $idx [expr $idx + 1]]
  set opt(-v) 1
}

if {$opt(-k)} {
} else {
  puts "Usage:"
  puts "% gfill.tcl -k foobar -v 999 *"
  return
}

set pattern $argv

set nlist [glob -nocomplain -type d {*}$pattern]

if {$opt(-v)} {
  foreach page $nlist {
    puts [format "gset -l %-20s %-15s \"%s\"" $page $key $value]
  }
} else {
  foreach page $nlist {
    set value [gvars -l $page $key]
    puts [format "gset -l %-20s %-15s \"%s\"" $page $key $value]
  }
}
