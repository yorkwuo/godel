#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
foreach i $argv {
  set cols [split $i :]
  plist $cols
}
