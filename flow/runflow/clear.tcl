#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirs [glob -type d *]

foreach dir $dirs {
  lsetvar $dir status ""
}
