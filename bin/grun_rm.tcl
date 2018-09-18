#!/usr/bin/env tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
grun_rm  [lindex $argv 0] [lindex $argv 1]
