#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
package require sqlite3
sqlite3 db1 [lindex $argv 0]

set sql {
  SELECT name FROM sqlite_master WHERE type='table';
}

set tname [db1 eval $sql]
puts $tname
puts ""

set sql "
  PRAGMA table_info('$tname');
"

db1 eval $sql ar {
  puts $ar(name)
}

db1 close
