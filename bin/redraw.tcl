#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

proc comparelength {a b} {
  expr {[string length $a] - [string length $b]}
}

catch {exec find ./ -name ".godel"} results

set results [lsort -decreasing -command comparelength $results]

foreach line $results {
  set dir [file dirname $line]
  puts $dir
  catch {exec godel_draw.tcl $dir} msg
  puts $msg
}

