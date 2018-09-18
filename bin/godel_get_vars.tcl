#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
source $env(GODEL_CENTER)/vars.tcl
puts [godel_get_vars [lindex $argv 0]]
