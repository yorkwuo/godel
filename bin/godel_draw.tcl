#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
set flow [lindex $argv 0]
godel_draw $flow [lindex $argv 1]
