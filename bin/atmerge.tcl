#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set f1 [lindex $argv 0]
set f2 [lindex $argv 1]
set out [lindex $argv 2]

if {[llength $argv] eq "2"} {
  set out $f2
}

source $f2
source $f1

godel_array_save atvar $out
